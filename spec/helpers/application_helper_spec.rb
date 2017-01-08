# frozen_string_literal: true
require "rails_helper"

describe ApplicationHelper, type: :helper do
  before do
    allow(controller).to receive(:controller_path) { "books" }
    allow(controller).to receive(:controller_name) { "book" }
    allow(helper).to receive(:current_object) { NilClass }
  end

  context "when all arguments are given" do
    describe "#jr_collection(:genre, :book)" do
      it { expect(helper.jr_collection(:genre, :book)).to include("奇幻" => :fantasy) }
    end

    describe "#jr_collection(:no_attribute, :no_model)" do
      it { expect { helper.jr_collection(:no_attribute, :no_model) }.to raise_error(NoMethodError) }
    end

    describe "#jr_attr(:director, :movie)" do
      it { expect(helper.jr_attribute(:director, :movie)).to eq "導演" }
    end

    describe "#jr_attr(:no_attribute, :no_model)" do
      it { expect(helper.jr_attribute(:no_attribute, :no_model)).to match(/translation missing:/) }
    end

    describe "#jr_value(:genre, :fantasy, :book)" do
      it { expect(helper.jr_value(:genre, :fantasy, :book)).to eq "奇幻" }
    end

    describe "#jr_value(:no_attribute, :no_value, :no_model)" do
      it { expect(helper.jr_value(:no_attribute, :no_value, :no_model)).to match(/translation missing:/) }
    end

    describe "#jr_row(:author, 東野圭吾, :book)" do
      it { expect(helper.jr_row(:author, "東野圭吾", :book)).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>" }
    end

    describe "#jr_row(:no_attribute, :no_value, :no_model)" do
      it { expect(helper.jr_row(:no_attribute, :no_value, :no_model)).to match(/translation missing:/) }
    end

    describe "#jr_row_val(:genre, :fantasy, :book)" do
      it { expect(helper.jr_row_val(:genre, :fantasy, :book)).to eq "<tr><th>類別</th><td>奇幻</td></tr>" }
    end

    describe "#jr_row_val(:no_attribute, :no_value, :no_model)" do
      it { expect { helper.jr_row_val(:genre) }.to raise_error(NoMethodError) }
    end
  end

  context "when arguments are omitted" do
    context "when current_object is available" do
      before do
        book = FactoryGirl.create(:book)
        allow(controller).to receive(:params) { { id: 1 } }
        allow(helper).to receive(:current_object) { book }
      end

      describe "#jr_collection(:genre)" do
        it { expect(helper.jr_collection(:genre)).to include("奇幻" => :fantasy) }
      end

      describe "#jr_attr(:genre)" do
        it { expect(helper.jr_attribute(:genre)).to eq "類別" }
      end

      describe "#jr_value(:genre, :fantasy)" do
        it { expect(helper.jr_value(:genre, :fantasy)).to eq "奇幻" }
      end

      describe "#jr_row(:author, 東野圭吾)" do
        it { expect(helper.jr_row(:author, "東野圭吾")).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>" }
      end

      describe "#jr_row(:author)" do
        it { expect(helper.jr_row(:author)).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>" }
      end

      describe "#jr_row_val(:genre, :fantasy)" do
        it { expect(helper.jr_row_val(:genre, :fantasy)).to eq "<tr><th>類別</th><td>奇幻</td></tr>" }
      end
    end

    context "when current_object fails, fallbacks to controller_name" do
      describe "#jr_collection(:genre)" do
        it { expect(helper.jr_collection(:genre)).to include("奇幻" => :fantasy) }
      end

      describe "#jr_attr(:genre)" do
        it { expect(helper.jr_attribute(:genre)).to eq "類別" }
      end

      describe "#jr_value(:genre, :fantasy)" do
        it { expect(helper.jr_value(:genre, :fantasy)).to eq "奇幻" }
      end

      describe "#jr_row(:author, 東野圭吾)" do
        it { expect(helper.jr_row(:author, "東野圭吾")).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>" }
      end

      describe "#jr_row(:author)" do
        it { expect { helper.jr_row(:author) }.to raise_error(NoMethodError) }
      end

      describe "#jr_row_val(:genre, :fantasy)" do
        it { expect(helper.jr_row_val(:genre, :fantasy)).to eq "<tr><th>類別</th><td>奇幻</td></tr>" }
      end
    end
  end

  describe "#jr_page_title" do
    describe "GET admin/sales#index" do
      it "generates the title based on the current controller and action" do
        allow(controller).to receive(:controller_path) { "admin/sales" }
        allow(controller).to receive(:action_name) { "index" }
        expect(helper.jr_page_title).to eq "銷售管理 | 翻譯蒟蒻"
      end
    end

    describe "GET no_controller/#no_action" do
      it "fallbacks to the app title" do
        allow(controller).to receive(:controller_path) { :no_controller }
        allow(controller).to receive(:action_name) { :no_action }
        expect(helper.jr_page_title).to eq "翻譯蒟蒻"
      end
    end
  end

  describe "#jr_content_for_page_title" do
    before do
      allow(controller).to receive(:controller_path) { :books }
      allow(controller).to receive(:action_name) { :edit }
    end

    context "when given a value" do
      it "prepends to #jr_page_title" do
        helper.jr_content_for_page_title("神探伽利略")
        expect(view.content_for(:jr_title)).to eq "神探伽利略 | 修改書籍 | 翻譯蒟蒻"
      end
    end

    context "when not given a value" do
      it "fallbacks to #jr_page_title" do
        helper.jr_content_for_page_title
        expect(view.content_for(:jr_title)).to eq "修改書籍 | 翻譯蒟蒻"
      end
    end
  end

  describe "#jr_simple_title" do
    context "when the locale file has the matching data" do
      it "translates the value" do
        expect(helper.jr_simple_title("admin/sales", :index)).to eq "銷售管理"
      end
    end

    context "when only given the controller name" do
      it "translates with _label" do
        expect(helper.jr_simple_title(:books)).to eq "我的書櫃"
      end
    end

    context "when given no arguments" do
      it "defaults to the current controller and action" do
        allow(controller).to receive(:controller_path) { :books }
        allow(controller).to receive(:action_name) { :edit }
        expect(helper.jr_simple_title).to eq "修改書籍"
      end
    end

    context "when the locale file does not have matching data" do
      it "returns an error message" do
        expect(helper.jr_simple_title(:no_controller, :no_action)).to match(/translation missing:/)
      end
    end
  end
end

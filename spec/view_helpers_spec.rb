# frozen_string_literal: true
require "jurou/view_helpers"
require "i18n"
require "action_view"
require_relative "fixtures/rails_test_helper"

describe Jurou::ViewHelpers do
  before(:each) do
    I18n.config.available_locales = :"zh-TW"
    I18n.locale = :"zh-TW"
    I18n.load_path << "spec/fixtures/zh-TW.yml"
    @helper = Jurou::RailsTestHelper.new
    @helper_no_model = Jurou::RailsTestHelper.new(nil, :books)
  end

  describe "#jr_collection" do
    context "when the locale file has the matching data" do
      it "generates a translated hash" do
        expect(@helper.jr_collection(:genre, :book)).to include("奇幻" => :fantasy)
      end
    end

    context "when omitting the model" do
      it "fallbacks to the controller name" do
        expect(@helper_no_model.jr_collection(:genre)).to include("奇幻" => :fantasy)
      end
    end

    context "when the locale file does not have matching data" do
      it "raises an error" do
        expect { @helper.jr_collection(:no_attribute, :no_model) }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#jr_attribute" do
    context "when the locale file has the matching data" do
      it "translates the attribute" do
        expect(@helper.jr_attribute(:director, :movie)).to eq "導演"
      end
    end

    context "when omitting the model" do
      it "fallbacks to the controller name" do
        expect(@helper_no_model.jr_attribute(:genre)).to eq "類別"
      end
    end

    context "when the locale file does not have matching data" do
      it "returns an error message" do
        expect(@helper.jr_attribute(:no_attribute, :no_model)).to match(/translation missing:/)
      end
    end
  end

  describe "#jr_value" do
    context "when the locale file has the matching data" do
      it "translates the value" do
        expect(@helper.jr_value(:genre, :fantasy, :book)).to eq "奇幻"
      end
    end

    context "when omitting the model" do
      it "fallbacks to the controller name" do
        expect(@helper.jr_value(:genre, :fantasy)).to eq "奇幻"
      end
    end

    context "when the locale file does not have matching data" do
      it "returns an error message" do
        expect(@helper.jr_value(:no_attribute, :no_value, :no_model)).to match(/translation missing:/)
      end
    end
  end

  describe "#jr_table_row" do
    context "when the locale file has the matching data" do
      it "generates HTML with the original value" do
        expect(@helper.jr_table_row(:author, "東野圭吾", :book)).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>"
      end
    end

    context "when omitting the model" do
      it "fallbacks to the controller name" do
        expect(@helper_no_model.jr_table_row(:author, "東野圭吾")).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>"
      end
    end

    context "when the locale file does not have matching data" do
      it "returns an error message" do
        expect(@helper.jr_table_row(:author, "東野圭吾", :movie)).to match(/translation missing:/)
      end
    end
  end

  describe "#jr_table_row_translate_value" do
    context "when the locale file has the matching data" do
      it "generates HTML with the translated value" do
        expect(@helper.jr_table_row_translate_value(:genre, :fantasy, :book)).to eq "<tr><th>類別</th><td>奇幻</td></tr>"
      end
    end

    context "when omitting the model" do
      it "fallbacks to the controller name" do
        expect(@helper_no_model.jr_table_row_translate_value(:genre, :fantasy)).to eq "<tr><th>類別</th><td>奇幻</td></tr>"
      end
    end

    context "when the locale file does not have matching data" do
      it "returns an error message" do
        expect(@helper.jr_table_row_translate_value(:author, "東野圭吾", :movie)).to match(/translation missing:/)
      end
    end
  end

  describe "#jr_page_title" do
    context "when the locale file has the matching data" do
      it "generates the title based on the current controller and action" do
        @helper_title = Jurou::RailsTestHelper.new("index", "admin/sales")
        expect(@helper_title.jr_page_title).to eq "銷售管理 | 翻譯蒟蒻"
      end
    end

    context "when the locale file does not have matching data" do
      it "fallbacks to the app title" do
        @helper_title = Jurou::RailsTestHelper.new("no_action", "no_controller")
        expect(@helper_title.jr_page_title).to eq "翻譯蒟蒻"
      end
    end
  end

  describe "#jr_content_for_page_title" do
    before(:each) { @helper_title = Jurou::RailsTestHelper.new("edit") }
    context "when given a value" do
      it "prepends to #jr_page_title" do
        expect(@helper_title.jr_content_for_page_title("神探伽利略")).to eq "神探伽利略 | 修改書籍 | 翻譯蒟蒻"
      end
    end

    context "when not given a value" do
      it "fallbacks to #jr_page_title" do
        expect(@helper_title.jr_content_for_page_title).to eq "修改書籍 | 翻譯蒟蒻"
      end
    end
  end

  describe "#jr_simple_title" do
    context "when the locale file has the matching data" do
      it "translates the value" do
        expect(@helper.jr_simple_title("admin/sales", :index)).to eq "銷售管理"
      end
    end

    context "when only given the controller name" do
      it "translates with _label" do
        expect(@helper.jr_simple_title(:books)).to eq "我的書櫃"
      end
    end

    context "when given no arguments" do
      it "defaults to the current controller and action" do
        @helper_simple = Jurou::RailsTestHelper.new("edit", "books")
        expect(@helper_simple.jr_simple_title).to eq "修改書籍"
      end
    end

    context "when the locale file does not have matching data" do
      it "returns an error message" do
        expect(@helper.jr_simple_title(:no_controller, :no_action)).to match(/translation missing:/)
      end
    end
  end
end

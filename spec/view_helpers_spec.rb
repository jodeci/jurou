require "jurou/view_helpers"
require "i18n"
require "action_view"
require_relative "fixtures/rails_test_helper"

describe Jurou::ViewHelpers do
  before(:each) do
    I18n.config.available_locales = :"zh-TW"
    I18n.locale= :"zh-TW"
    I18n.load_path << "spec/fixtures/zh-TW.yml"
    @helper = Jurou::RailsTestHelper.new
  end

  describe "#jr_collection" do
    context "when the locale file has the matching data" do
      it "should generate a translated hash" do
        expect(@helper.jr_collection(:genre, :book)).to include({ "奇幻" => :fantasy })
      end
    end

    context "when the locale file does not have matching data" do
      it "should raise an error" do
        expect { @helper.jr_collection(:no_attribute, :no_model) }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#jr_attribute" do
    context "when model is specified" do
      it "should translate the attribute" do
        expect(@helper.jr_attribute(:director, :movie)).to eq "導演"
      end
    end

    context "when model is not specified" do
      it "should look for the translation in :current_object" do
        expect(@helper.jr_attribute(:genre)).to eq "類別"
      end
    end

    context "when the locale file does not have matching data" do
      it "should return an error message" do
        expect(@helper.jr_attribute(:no_attribute, :no_model)).to match /\Atranslation missing:/
      end
    end

    context "when everything else fails" do
      it "should raise an error" do
        @helper_fail = Jurou::RailsTestHelper.new(nil, nil, nil)
        expect { @helper_fail.jr_attribute(:genre) }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#jr_value" do
    context "when the locale file has the matching data" do
      it "should translate the value" do
        expect(@helper.jr_value(:genre, :book, :fantasy)).to eq "奇幻"
      end
    end

    context "when the locale file does not have matching data" do
      it "should return an error message" do
        expect(@helper.jr_value(:no_attribute, :no_model, :no_value)).to match /\Atranslation missing:/
      end
    end
  end

  describe "#jr_table_row" do
    context "when the value does not need translation" do
      it "should generate HTML with the original value" do
         expect(@helper.jr_table_row(:author, :book, "東野圭吾")).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>"
      end
    end

    context "when the value needs translation" do
      it "should generate HTML with the translated value" do
        expect(@helper.jr_table_row(:genre, :book, :fantasy, :true)).to eq "<tr><th>類別</th><td>奇幻</td></tr>"
      end
    end
  end

  describe "#jr_page_title" do
    context "when the locale file has the matching data" do
      it "should generate the title based on the current controller and action" do
        @helper_title = Jurou::RailsTestHelper.new("index", "admin/sales")
        expect(@helper_title.jr_page_title).to eq "銷售管理 | 翻譯蒟蒻"
      end
    end

    context "when the locale file does not have matching data" do
      it "should fall back to the app title" do
        @helper_title = Jurou::RailsTestHelper.new("no_action", "no_controller")
        expect(@helper_title.jr_page_title).to eq "翻譯蒟蒻"
      end
    end
  end

  describe "#jr_content_for_page_title" do
    before(:each) { @helper_title = Jurou::RailsTestHelper.new("edit") }
    context "when given a value" do
      it "should prepend to #jr_page_title" do
        expect(@helper_title.jr_content_for_page_title("神探伽利略")).to eq "神探伽利略 | 修改書籍 | 翻譯蒟蒻"
      end
    end

    context "when not given a value" do
      it "should fall back to #jr_page_title" do
        expect(@helper_title.jr_content_for_page_title).to eq "修改書籍 | 翻譯蒟蒻"
      end
    end
  end

  describe "#jr_simple_title" do
    context "when the locale file has the matching data" do
      it "should translate the value" do
        expect(@helper.jr_simple_title("admin/sales", :index)).to eq "銷售管理"
      end
    end

    context "when only given the controller name" do
      it "should translate with _label" do
        expect(@helper.jr_simple_title(:books)).to eq "我的書櫃"
      end
    end

    context "when the locale file does not have matching data" do
      it "should return an error message" do
        expect(@helper.jr_simple_title(:no_controller, :no_action)).to match /\Atranslation missing:/
      end
    end
  end
end

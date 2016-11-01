require "jurou/view_helpers"
require "i18n"
require "action_view"

describe Jurou::ViewHelpers do
  before(:each) do
    I18n.config.available_locales = :"zh-TW"
    I18n.locale= :"zh-TW"
    I18n.load_path << "spec/fixtures/zh-TW.yml"
    @helper =
      class Helper
        include Jurou::ViewHelpers
        include ActionView::Helpers
        include ActionView::Context
      end.new
  end

  it "jr_attribute should get the correct value" do
    expect(@helper.jr_attribute(:genre, :book)).to eq "類別"
  end

  it "jr_value should get the correct value" do
    expect(@helper.jr_value(:genre, :book, :fantasy)).to eq "奇幻"
  end

  context "jr_table_row should generate the correct HTML" do
    it "without translation" do
      expect(@helper.jr_table_row(:author, :book, "東野圭吾")).to eq "<tr><th>作者</th><td>東野圭吾</td></tr>"
    end

    it "with translation" do
      expect(@helper.jr_table_row(:genre, :book, :fantasy, :true)).to eq "<tr><th>類別</th><td>奇幻</td></tr>"
    end
  end
end

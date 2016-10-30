require "jurou/view_helpers"
require "i18n"
describe Jurou::ViewHelpers do
  before(:each) do
    I18n.config.available_locales = :"zh-TW"
    I18n.locale= :"zh-TW"
    I18n.load_path << "spec/fixtures/zh-TW.yml"
    @helper =
      class Helper
        include Jurou::ViewHelpers
      end.new
  end

  it "jr_attribute should get the correct value" do
    expect(@helper.jr_attribute(:genre, :book)).to eq "類別"
  end

  it "jr_value should get the correct value" do
    expect(@helper.jr_value(:genre, :book, :fantasy)).to eq "奇幻"
  end
end

require 'spec_helper'

class Klass
  extend Defaults::Constants
end


describe Defaults::Constants do
  before :each do
    Defaults::Constants.set_tier('local')
  end

  it "sets the correct tier" do
    expect(Defaults::Constants.instance_variable_get(:@tier)).to eql('local')
  end

  it "returns correct url for localhost TA" do
    expect(Defaults::Constants.url_mapping('treatment')).to match('localhost:10235')
  end

  it "returns correct host for int TA" do
    Defaults::Constants.set_tier('int')
    expect(Defaults::Constants.url_mapping('treatment')).to  match('https://pedmatch-int.nci.nih.gov')
  end

  it "returns correct host for uat TA" do
    Defaults::Constants.set_tier('uat')
    expect(Defaults::Constants.url_mapping('treatment')).to  match('https://pedmatch-uat.nci.nih.gov')
  end

  it "returns correct host for TA" do
    Defaults::Constants.set_tier('prod')
    expect(Defaults::Constants.url_mapping('treatment')).to  match('https://pedmatch.nci.nih.gov')
  end

  it "returns the correct url for Patient" do
    expect(Defaults::Constants.url_patient_api).to eql('http://localhost:10240/api/v1/patients')
  end

  it "raises error for invalid tier" do
    expect {Defaults::Constants.set_tier('apple')}
  end
end
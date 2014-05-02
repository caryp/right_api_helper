require 'right_api_helper'

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { :record => :all }
end

RSpec.configure do |c|
  # so we can use :vcr rather than :vcr => true;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

describe RightApiHelper::Deployments do

  before(:all) do
    # Get API session
    VCR.use_cassette('right_api_session') do
      @api_helper = RightApiHelper::API15.new()
      @api_helper.connection_file("~/.right_api_client/login.yml")
    end
    VCR.use_cassette('right_api_general') do
      @deployment_helper = RightApiHelper::Deployments.new(@api_helper)
    end
  end

  it "finds existing deployments" do
    VCR.use_cassette('right_api_general') do
      @deployment_helper.should_receive(:log_info).exactly(2)
      deployment = @deployment_helper.find_or_create("Default")
      deployment.name.should == "Default"
    end
  end

  it "creates new deployment if not found" do
    VCR.use_cassette('right_api_general') do
      @deployment_helper.should_receive(:log_info).exactly(3)
      deployment = @deployment_helper.find_or_create("TEST:right_api_helper deleteme!")
      deployment.show.name.should == "TEST:right_api_helper deleteme!"
      deployment.destroy
    end
  end

  pending "adds an instance to a deployment" do
  end

end
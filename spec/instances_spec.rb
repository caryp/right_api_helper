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

describe RightApiHelper::Instances do

  before(:all) do
    # Get API session
    VCR.use_cassette('right_api_session') do
      @api_helper = RightApiHelper::API15.new()
      @api_helper.connection_file("~/.right_api_client/login.yml")
    end
    VCR.use_cassette('right_api_general') do
      @helper = RightApiHelper::Instances.new(@api_helper)
    end
  end

  pending "adds instance to a deployment" do
    VCR.use_cassette('right_api_general') do
      instance = @helper.find_instance_by_href("/api/clouds/3/instances/18UBA2151G2BQ")
      puts instance.name
    end
  end

end
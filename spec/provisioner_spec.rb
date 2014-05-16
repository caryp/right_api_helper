require 'spec_helper'

describe RightApiHelper::Provisioner do

  it "initializes" do
    VCR.use_cassette('right_api_session') do
      session = RightApiHelper::Session.new
      session.should_receive(:setup_client_logging)
      @right_api_client = session.create_client_from_file("~/.right_api_client/login.yml")
    end
    VCR.use_cassette('right_api_general') do
      @helper = RightApiHelper::Provisioner.new(@right_api_client)
      @logger = double("Logger")
      @helper.logger(@logger)
    end
  end

end

#
# Author: cary@rightscale.com
# Copyright 2014 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe RightApiHelper::Deployments do

  before(:all) do
    # Get API session
    VCR.use_cassette('right_api_session') do
      session = RightApiHelper::Session.new
      session.should_receive(:setup_client_logging)
      @right_api_client = session.create_client_from_file("~/.right_api_client/login.yml")
    end
    VCR.use_cassette('right_api_general') do
      @deployment_helper = RightApiHelper::Deployments.new(@right_api_client)
      @logger = stub("Logger")
      @deployment_helper.logger(@logger)
    end
  end

  it "finds existing deployments" do
    VCR.use_cassette('right_api_general') do
      @logger.should_receive(:info).exactly(2)
      deployment = @deployment_helper.find_or_create("Default")
      deployment.name.should == "Default"
    end
  end

  it "creates new deployment if not found" do
    VCR.use_cassette('right_api_general') do
      @logger.should_receive(:info).exactly(3)
      deployment = @deployment_helper.find_or_create("TEST:right_api_helper deleteme!")
      deployment.show.name.should == "TEST:right_api_helper deleteme!"
      deployment.destroy
    end
  end

  it "adds an instance to a deployment" do
    pending("this feature not yet supported by RightScale API")
  end

end
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

describe RightApiHelper::Session do

  it "creates an client" do
    VCR.use_cassette('right_api_session') do
      apiStub = double("RightApi::Client", :api_url => "http://foo.com", :log => "")
      RightApi::Client.should_receive(:new).and_return(apiStub)
      session = RightApiHelper::Session.new
      session.should_receive(:setup_client_logging)
      session.logger(double("Logger"))
      @client = session.create_client("someemail", "somepasswd", "someaccountid", "https://my.rightscale.com")
      @client.should_not == nil
    end
  end

  it "creates an client from file" do
    VCR.use_cassette('right_api_session') do
      apiStub = double("RightApi::Client", :api_url => "http://foo.com", :log => "")
      RightApi::Client.should_receive(:new).and_return(apiStub)
      session = RightApiHelper::Session.new
      session.should_receive(:setup_client_logging)
      session.logger(double("Logger"))
      @client = session.create_client_from_file("~/.right_api_client/login.yml")
      @client.should_not == nil
    end
  end

end
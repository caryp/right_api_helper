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

require 'right_api_helper'

describe RightApiHelper::DeploymentsCreator do

  before(:all) do
    @dc = RightApiHelper::DeploymentsCreator.new
  end

  @real_file = File.join(File.dirname(__FILE__),"..","data","deployments.json")
  let (:bogus_file) { File.join(File.dirname(__FILE__),"..","data","iamnothere.json")  }

  it "exits with error if no argument is passed" do
    argv = []
    @dc.should_receive(:log_error)
    lambda{ @dc.run(argv) }.should raise_error SystemExit
  end

  it "exits with error argument empty filename is passed" do
    argv = [""]
    @dc.should_receive(:log_error)
    lambda{ @dc.run(argv) }.should raise_error SystemExit
  end

  it "exits with error invalid filename is passed" do
    argv = [ File.join(File.dirname(__FILE__),"..","data","iamnothere.json") ]
    @dc.should_receive(:log_error)
    lambda{ @dc.run(argv) }.should raise_error SystemExit
  end

  it "reads a json file into memory" do
    # grab test data
    test_file = File.join(File.dirname(__FILE__),"..","data","deployments.json")
    test_data = File.open(test_file, "r") {|f| f.read }

    # Compare class json with test data
    argv = [ File.join(File.dirname(__FILE__),"..","data","deployments.json") ]
    @dc.run(argv)

    @dc.instance_variable_get("@json").should == test_data
  end

end
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

describe RightApiHelper::Cache do

  before(:each) do
    @helper = RightApiHelper::Cache.new("test_cache")
    @helper.logger(double("Logger", :info => nil))
    @test_hash = { "lame saying" => "hey now!", :foo => :bar }
  end

  it "clears a cache file" do
    File.should_receive(:exists?).exactly(1).and_return(true)
    File.should_receive(:delete).exactly(1)
    @helper.clear
  end

  it "does not clear a cache file if it does not exist" do
    File.should_receive(:exists?).exactly(1).and_return(false)
    File.should_receive(:delete).exactly(0)
    @helper.clear
  end

  it "returns nil if no cache file" do
    File.should_receive(:exists?).exactly(1).and_return(false)
    @helper.get.should == nil
  end

  it "writes a hash to a cache file" do
    io_stub = double('fakefile', :write => nil)
    File.should_receive(:open).and_return(io_stub)
    @helper.set(@test_hash)
  end

  it "returns cache file contents" do
    File.should_receive(:exists?).exactly(1).and_return(true)
    File.should_receive(:open).and_return(YAML.dump(@test_hash))
    @helper.get.should == @test_hash
  end

end
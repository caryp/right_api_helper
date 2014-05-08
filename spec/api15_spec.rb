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

require 'json'
require 'right_api_client'
require 'right_api_helper'

describe "API15 object" do

  BAD_USER_DATA = "RS_server=my.rightscale.com&RS_token=89eeb0b19af40b5b72668dc3caa9934a&RS_sketchy=sketchy1-166.rightscale.com"

  before(:each) do
    apiStub = double("RightApi::Client", :api_url => "http://foo.com", :log => "")
    RightApi::Client.should_receive(:new).and_return(apiStub)
    @right_api_client = RightApiHelper::Session.new.create_client("someemail", "somepasswd", "someaccountid", "https://my.rightscale.com")
    @api = RightApiHelper::API15.new(@right_api_client)
  end

  it "should find deployment by name" do
    deploymentsStub = double("deployments", :index => [ :name => "my_fake_deployment" ])
    @api.instance_variable_get("@client").should_receive(:deployments).and_return(deploymentsStub)
    @api.find_deployment_by_name("my_fake_deployment")
  end

  it "should raise error if deployment not found by name" do
    deploymentsStub = double("deployments", :index => nil)
    @api.instance_variable_get("@client").should_receive(:deployments).and_return(deploymentsStub)
    lambda{@api.find_deployment_by_name("my_fake_deployment")}.should raise_error
  end

  it "should raise error if multiple deployments found by name" do
    deploymentsStub = double("deployments", :index => [ {:name => "my_fake_deployment"}, {:name => "my_fake_deployment2"} ])
    @api.instance_variable_get("@client").should_receive(:deployments).and_return(deploymentsStub)
    lambda{@api.find_deployment_by_name("my_fake_deployment")}.should raise_error
  end

  it "should find server by name" do
    serversStub = double("servers", :index => [ :name => "my_fake_server" ])
    @api.instance_variable_get("@client").should_receive(:servers).and_return(serversStub)
    @api.find_server_by_name("my_fake_server")
  end

  it "should raise error if multiple servers found by name" do
    serversStub = double("servers", :index => [ {:name => "my_fake_server"}, {:name => "my_fake_server2"} ])
    @api.instance_variable_get("@client").should_receive(:servers).and_return(serversStub)
    lambda{@api.find_server_by_name("my_fake_server")}.should raise_error
  end

  it "should find cloud by name" do
    cloudsStub = double("clouds", :index => [ :name => "my_fake_cloud" ])
    @api.instance_variable_get("@client").should_receive(:clouds).and_return(cloudsStub)
    @api.find_cloud_by_name("my_fake_cloud")
  end

  it "should raise error if cloud not found by name" do
    cloudsStub = double("clouds", :index => nil)
    @api.instance_variable_get("@client").should_receive(:clouds).and_return(cloudsStub)
    lambda{@api.find_cloud_by_name("my_fake_cloud")}.should raise_error
  end

  it "should find MCI by name" do
    mcisStub = double("multi_cloud_images", :index => [ :name => "my_fake_mci" ])
    @api.instance_variable_get("@client").should_receive(:multi_cloud_images).and_return(mcisStub)
    @api.find_mci_by_name("my_fake_mci")
  end

  it "should raise error if multiple MCI found by name" do
    mcisStub = double("multi_cloud_images", :index => [ {:name => "my_fake_mci"}, {:name => "my_fake_mci2"} ])
    @api.instance_variable_get("@client").should_receive(:multi_cloud_images).and_return(mcisStub)
    lambda{@api.find_mci_by_name("my_fake_mci")}.should raise_error
  end

  it "should find servertemplate by name" do
    servertemplatesStub = double("servertemplates", :index => [ double("servertemplate", :name => "my_fake_servertemplate", :revision => [0, 1, 2, 3, 4 ]) ])
    @api.instance_variable_get("@client").should_receive(:server_templates).and_return(servertemplatesStub)
    @api.find_servertemplate("my_fake_servertemplate")
  end

  it "should raise error if no servertemplates found by name" do
    servertemplatesStub = double("servertemplates", :index => [])
    @api.instance_variable_get("@client").should_receive(:server_templates).and_return(servertemplatesStub)
    lambda{@api.find_servertemplate("my_fake_servertemplate")}.should raise_error
  end

  it "should raise error if multiple servertemplates found by name" do
    servertemplatesStub = double("servertemplates", :index => [ double("servertemplate", :name => "my_fake_servertemplate"), double("servertemplate", :name => "my_fake_servertemplate") ])
    @api.instance_variable_get("@client").should_receive(:server_templates).and_return(servertemplatesStub)
    lambda{@api.find_servertemplate("my_fake_servertemplate")}.should raise_error
  end

  it "should find servertemplate by id" do
    servertemplatesStub = double("servertemplates", :index => [ :name => "my_fake_servertemplate" ])
    @api.instance_variable_get("@client").should_receive(:server_templates).and_return(servertemplatesStub)
    @api.find_servertemplate(1234)
  end

  it "should create deployment" do
    deploymentsStub = double("deployments", :create => [ {:name => "my_fake_deployment"} ])
    @api.instance_variable_get("@client").should_receive(:deployments).and_return(deploymentsStub)
    deploymentsStub.should_receive(:create)
    @api.create_deployment("my_deployment")
  end

  it "should destroy a deployment" do
    deploymentsStub = double("deployments", :destroy => nil)
    deploymentsStub.should_receive(:destroy)
    @api.destroy_deployment(deploymentsStub)
  end

  it "should create server with the default MCI" do
    dStub = double("deployment", :href => "/some/fake/path")
    dsStub = double("deployments", :show => dStub)
    @api.should_receive(:create_deployment).and_return(dsStub)
    deployment = @api.create_deployment("my_deployment")

    stStub = double("servertemplate", :href => "/some/fake/path", :show => "")
    stsStub = double("servertemplates", :show => stStub)
    @api.should_receive(:find_servertemplate).and_return(stsStub)
    server_template = @api.find_servertemplate(1234)

    cStub = double("cloud", :href => "/some/fake/path")
    csStub = double("clouds", :show => cStub)
    @api.should_receive(:find_cloud_by_name).and_return(csStub)
    cloud = @api.find_cloud_by_name(1234)

    serversStub = double("servers", :create => [ :name => "my_fake_server" ])
    @api.instance_variable_get("@client").should_receive(:servers).and_return(serversStub)
    @api.create_server(deployment, server_template, nil, cloud, "my_fake_server")
  end

  it "should create server with the MCI given" do
    dStub = double("deployment", :href => "/some/fake/path")
    dsStub = double("deployments", :show => dStub)
    @api.should_receive(:create_deployment).and_return(dsStub)
    deployment = @api.create_deployment("my_deployment")

    stStub = double("servertemplate", :href => "/some/fake/path", :show => "")
    stsStub = double("servertemplates", :show => stStub)
    @api.should_receive(:find_servertemplate).and_return(stsStub)
    server_template = @api.find_servertemplate(1234)

    mciStub = double("mci", :href => "/some/fake/path")
    mcisStub = double("mcis", :show => mciStub)
    @api.should_receive(:find_mci_by_name).and_return(mcisStub)
    mci = @api.find_mci_by_name("CentOS")

    cStub = double("cloud", :href => "/some/fake/path")
    csStub = double("clouds", :show => cStub)
    @api.should_receive(:find_cloud_by_name).and_return(csStub)
    cloud = @api.find_cloud_by_name(1234)

    serversStub = double("servers", :create => [ :name => "my_fake_server" ])
    @api.instance_variable_get("@client").should_receive(:servers).and_return(serversStub)
    @api.create_server(deployment, server_template, mci, cloud, "my_fake_server")
  end

  it "should launch server with inputs" do
    serverStub = double("server", :name => "foo")
    serversStub = double("servers", :launch => true, :show => serverStub, :index => [ :name => "my_fake_server" ])
    @api.should_receive(:create_server).and_return(serversStub)
    server = @api.create_server("foo", "bar", "my_fake_server")
    @api.instance_variable_get("@client").should_receive(:servers).and_return(serversStub)
    @api.launch_server(server, [ {:name => "input1", :value => 1} ])
  end

  it "should launch server without inputs" do
    serverStub = double("server", :name => "foo")
    serversStub = double("servers", :launch => true, :show => serverStub, :index => [ :name => "my_fake_server" ])
    @api.should_receive(:create_server).and_return(serversStub)
    server = @api.create_server("foo", "bar", "my_fake_server")
    @api.instance_variable_get("@client").should_receive(:servers).and_return(serversStub)
    @api.launch_server(server)
  end

  it "returns user_data" do
    instanceDataStub = double("idata", :user_data => "someuserdata")
    instanceStub = double("instance", :show => instanceDataStub)
    serverDataStub = double("sdata", :current_instance => instanceStub)
    serverStub = double("server", :show => serverDataStub)
    serverDataStub.should_receive(:current_instance).with(:view=>"extended")
    @api.user_data(serverStub).should == "someuserdata"
  end

  it "returns data_request_url for instance" do
    @user_data = "RS_rn_url=amqp://b915586461:278a854748@orange2-broker.test.rightscale.com/right_net&RS_rn_id=4985249009&RS_server=orange2-moo.test.rightscale.com&RS_rn_auth=d98106775832c174ffd55bd7b7cb175077574adf&RS_token=b233a57d1d24f27bd8650d0f9b6bfd54&RS_sketchy=sketchy1-145.rightscale.com&RS_rn_host=:0"
    @request_data_url = "https://my.rightscale.com/servers/data_injection_payload/d98106775832c174ffd55bd7b7cb175077574adf"
    @right_api_client.should_receive(:api_url).and_return("https://my.rightscale.com")
    @api.data_request_url(@user_data).should == @request_data_url
  end

  it "returns true if server has a current instance" do
    serverDataStub = double("sdata", :api_methods => [:current_instance])
    serverStub = double("server", :show => serverDataStub)
    @api.is_provisioned?(serverStub).should == true
  end

  it "returns false if server does not have a current instance" do
    serverDataStub = double("sdata", :api_methods => [])
    serverStub = double("server", :show => serverDataStub)
    @api.is_provisioned?(serverStub).should == false
  end

  it "will not wait if server is in expected state" do
    @api.should_receive(:server_state).and_return("booting")
    @api.server_wait_for_state("fakeserver", "booting")
  end

  it "throws an error if server is stranded" do
    @api.should_receive(:server_state).and_return("stranded")
    @api.set_bad_states([ "stranded", "terminated"])
    lambda{@api.server_wait_for_state("fakeserver", "operational")}.should raise_error
  end

  it "returns the server's cloud" do
    cData = double("clouddata", :name => "cloudname")
    cStub = double("cloud", :show => cData)
    @api.should_receive(:instance_from_server)
    @api.should_receive(:cloud_from_instance).and_return(cStub)
    @api.server_cloud_name("foo").should == "cloudname"
  end

  it "returns the current instance from the server is provisioned" do
    serverDataStub = double("sdata", :current_instance => "current")
    serverStub = double("server", :show => serverDataStub)
    @api.should_receive(:is_provisioned?).and_return(true)
    @api.send(:instance_from_server, serverStub).should == "current"
  end

  it "returns the next instance from the server is not provisioned" do
    serverDataStub = double("sdata", :next_instance => "next")
    serverStub = double("server", :show => serverDataStub)
    @api.should_receive(:is_provisioned?).and_return(false)
    @api.send(:instance_from_server, serverStub).should == "next"
  end

  it "returns server state" do
    instanceDataStub = double("idata", :state => "booting")
    instanceStub = double("instance", :show => instanceDataStub)
    @api.should_receive(:instance_from_server).and_return(instanceStub)
    @api.send(:server_state, "server").should == "booting"
  end

  it "returns the cloud from the instance" do
    instanceDataStub = double("idata", :cloud => "somecloudobj")
    instanceStub = double("instance", :show => instanceDataStub)
    @api.send(:cloud_from_instance, instanceStub).should == "somecloudobj"
  end

  it "sets inputs on the next instance" do
    inputsStub = double("inputs")
    inputsStub.should_receive(:multi_update).with({"inputs" => "heynow"})
    instanceDataStub = double("idata", :inputs => inputsStub)
    instanceStub = double("instance", :show => instanceDataStub)
    serverDataStub = double("sdata", :next_instance => instanceStub)
    serverStub = double("server", :show => serverDataStub)
    @api.set_server_inputs(serverStub, "heynow")
  end

  it "terminates a server" do
    serverStub = double("server")
    serverStub.should_receive(:terminate)
    @api.terminate_server(serverStub)
  end


end

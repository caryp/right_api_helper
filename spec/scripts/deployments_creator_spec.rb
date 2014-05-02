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
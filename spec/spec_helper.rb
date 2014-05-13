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

# Use the VCR gem for recording the API request/responses
# instead of mocking everything like I did in the api15_spec
require 'vcr'
require 'yaml'
require 'cgi'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  # Comment this to record new cassettes for fast unit testing
  c.default_cassette_options = { :record => :all }

  # filer out authentication data
  login_info = YAML::load(File.open("#{ENV['HOME']}/.right_api_client/login.yml"))
  c.before_record do |i|
    i.response.headers.delete('Set-Cookie')
    i.request.headers.delete('Cookie')
    i.request.headers.delete('Authorization')
  end
  c.filter_sensitive_data('<EMAIL>') { CGI::escape(login_info[:email].to_s) }
  c.filter_sensitive_data('<PASSWORD>') { CGI::escape(login_info[:password].to_s) }
  c.filter_sensitive_data('<ACCOUNT_ID>') { CGI::escape(login_info[:account_id].to_s)  }
end

RSpec.configure do |c|
  # so we can use :vcr rather than :vcr => true;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
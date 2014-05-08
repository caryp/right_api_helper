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

module RightApiHelper
  class Session < Base

    def initialize
      self.logger()
    end

    # Create a right_api_client session
    # See https://github.com/rightscale/right_api_client/blob/master/README.md#usage-instructions
    #
    # Returns: handle to right_api_client gem
    #
    def create_client(email, password, account_id, api_url=nil)
      begin
        args = { :email => email, :password => password, :account_id => account_id }
        args[:api_url] = api_url if api_url
        @client ||= RightApi::Client.new(args)
        setup_client_logging
        @client
      rescue Exception => e
        args.delete(:password) # don't log password
        puts "ERROR: could not connect to RightScale API.  Params: #{args.inspect}"
        puts e.message
        puts e.backtrace
        raise e
      end
    end

    # Create a right_api_client session from YAML file
    # See https://github.com/rightscale/right_api_client/blob/master/README.md#usage-instructions
    #
    # Returns: handle to right_api_client gem
    #
    def create_client_from_file(filename)
      begin
        @client ||= RightApi::Client.new(YAML.load_file(File.expand_path(filename, __FILE__)))
        setup_client_logging
        @client
      rescue Exception => e
        puts "ERROR: could not connect to RightScale API.  filename: '#{filename}'"
        puts e.message
        puts e.backtrace
        raise e
      end
    end

    private

    def setup_client_logging
      # right_api_client logs too much stuff, squelch it down a notch.
      right_api_log = @log.dup
      right_api_log.level = @log.level + 1

      @client.log(right_api_log)
    end

  end
end
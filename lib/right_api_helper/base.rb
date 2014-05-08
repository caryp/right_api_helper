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
require 'logger'

module RightApiHelper

  # Base helper class
  #
  class Base

    def initialize(right_api_client)
      @client = right_api_client
      logger
    end

    def api_url
      @client.api_url
    end

    def logger(logger=nil)
      @log = logger
      @log ||= default_logger
    end

    def log_level(level)
      @log.level = level
    end

    private

    def default_logger
      logger = Logger.new(STDOUT)
      logger.formatter = proc do |severity, datetime, progname, msg|
         "#{msg}\n"
      end
      logger
    end

  end
end
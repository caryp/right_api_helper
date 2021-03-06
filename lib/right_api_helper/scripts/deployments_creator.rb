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
  class DeploymentsCreator

    def run(argv)
      if argv.empty? or argv[0].empty?
        log_error "FATAL: you must supply path to json file"
        exit -1
      end
      filename = ""
      filename = argv[0] if argv[0]
      unless File.exists?(filename)
        log_error "FATAL: no such file: '#{filename}'"
        exit -2
      end

      @json = File.open(filename, "r") { |f| f.read }

    end

    private

    def log_error(message)
      puts message
    end

  end
end
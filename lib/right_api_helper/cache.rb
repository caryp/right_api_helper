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
  class Cache < Base

    def initialize(cache_uuid, cache_tmp_dir=".")
      logger
      @cache_file = File.join(cache_tmp_dir, "#{cache_uuid}.yml")
    end

    # Get all instances for all clouds registered in account
    def get
      hash = nil
      if File.exists?(@cache_file)
        @log.info "Reading cache from #{@cache_file}"
        hash = YAML::load(File.open(@cache_file))
      else
        @log.info "No cache found at #{@cache_file}"
      end
      hash
    end

    def set(hash)
      @log.info "Writing cache to #{@cache_file}"
      File.open(@cache_file, "w") { |f| f.write(YAML.dump(hash)) }
    end

    def clear
      if File.exists?(@cache_file)
        @log.info("removing cache file at #{@cache_file}")
        File.delete(@cache_file)
      else
        @log.info("no cache file to remove at #{@cache_file}")
      end
    end

  end
end
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
  class Instances < Base

    def initialize(right_api_client)
      super(right_api_client)
      @api_shim = RightApiHelper::API15.new(right_api_client)
    end

    # Get all instances for all clouds registered in account
    def get_instances
      instances = [ ]
      get_clouds.each do |cloud|
        instances += cloud.instances.index(:filter => [], :view => 'tiny')
      end
      instances
    end

    def get_unmanaged_instances
      get_instances.reject { |i| i.respond_to?(:deployment) }
    end

    private

    def get_clouds
      @client.clouds.index
    end

  end
end
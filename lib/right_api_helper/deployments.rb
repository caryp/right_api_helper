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
  class Deployments < Base

    def initialize(right_api_client)
      super(right_api_client)
      @api_shim = RightApiHelper::API15.new(right_api_client)
    end

    # Return: MediaType : right_api_client deployment
    def find_or_create(name)
      @log.info "Looking for deployment: '#{name}'..."
      deployment = @api_shim.find_deployment_by_name(name)
      @log.info "Deployment #{deployment.nil? ? "not found" : "found"}."
      unless deployment
        deployment = @api_shim.create_deployment(name)
        @log.info "Deployment created: '#{name}'"
      end
      deployment
    end

  end
end
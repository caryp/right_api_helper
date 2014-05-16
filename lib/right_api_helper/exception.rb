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
  class RightScaleError < StandardError
  end

  class MultipleMatchesFound < RightScaleError
    def initialize(resource, key, value)
      key = key.to_s.delete("by_") # remove the 'by_' prefix
      msg = "More than one #{resource} with the #{key} of '#{value}'. " +
            "Please resolve via the RightScale dashboard and retry."
      super msg
    end
  end
end
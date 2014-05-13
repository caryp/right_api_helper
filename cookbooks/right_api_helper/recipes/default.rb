#
# Cookbook Name:: right_api_helper
# Recipe:: default
#
# Copyright (C) 2014 RightScale, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# system setup
#
include_recipe "apt"
include_recipe "build-essential"

# install ruby 1.9
#
package "ruby1.9.1"
package "ruby1.9.1-dev"

bash "update-alternatives --set ruby /usr/bin/ruby1.9.1"
bash "update-alternatives --set gem /usr/bin/gem1.9.1"

# add RightScale API credentials
#
directory "/home/vagrant/.right_api_client"

template "/home/vagrant/.right_api_client/login.yml" do
  source "login.yml.erb"
  user "vagrant"
  mode 0600
  variables({
    :user_email => node['right_api_helper']['user_email'],
    :user_password => node['right_api_helper']['user_password'],
    :account_id => node['right_api_helper']['account_id']
  })
end

# install gem
#
gem_package "right_api_helper"





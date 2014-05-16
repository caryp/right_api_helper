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

# Basic helper gem for provisioning IaaS servers using the RightScale API.
#
# It is intended to be used by ruby applications that need to launch servers.
#
# ## Usage
#
# Example:
#
#   require "right_api_helper"
#
#   # initialize rightscale provisioner
#   @rightscale =
#     RightApiHelper::Provisioner.new("my_user@somewhere.com",  // user
#                                        "my_rightscale_password",   // password
#                                        12345)            // rightscale account ID
#
#   # setup some inputs
#   server_inputs = {
#        # open up port 8000
#        "sys_firewall/rule/enable" => "text:enable",
#        "sys_firewall/rule/port" => "text:8000",
#        "sys_firewall/rule/ip_address" => "text:any",
#        "sys_firewall/rule/protocol" => "text:tcp"
#     }
#
#   # provision a RightScale managed server from a ServerTemplate
#   @rightscale.provision("My Cool Server",
#                         "ServerTemplate for Linux (v13.5)", // name or ID
#                         "AWS US-East",
#                         "My Deployment",
#                         server_inputs)
#
#   # wait for server to be ready
#   state = @rightscale.wait_for_operational
#
#   # Do stuff with your brand new server...


module RightApiHelper

  #
  # This is the main class to use to create a server on the RightScale platform.
  # Use the {#provision} method to create and launch
  # the server.
  #
  # The other methods are for checking server state and gathering information
  # once the server is operational.
  #
  class Provisioner < Base

    RETRY_DELAY = 10 # seconds
    BAD_STATES_UP = [ "stranded", "terminated"]

    def initialize(right_api_client)
      super(right_api_client)
      @api_shim = RightApiHelper::API15.new(right_api_client)
    end

    def connection_url
      raise "No server provisioned. No connection URL available." unless @server
      unless @data_request_url
        user_data = @server.current_instance.show(:view => "full").user_data
        @data_request_url = @api_shim.data_request_url(user_data)
        @logger.debug "Data Request URL: #{@data_request_url}"
      end
      @data_request_url
    end

    # Provision a server using RightScale
    #
    # @param server_name [String] the name to give the server that will be
    #        created.
    # @param server_template [String] the name or ID of the ServerTemplate to
    #        create the server from.
    # @param cloud_name [String] name of cloud to provision on.
    # @param deployment_name [String] name of deployment to add the server to.
    #        This will be created if it does not exist.
    # @param inputs [Array] An array of {Input} objects.
    # @param ssh_key_id [String] The resource_uuid of an ssh key from the
    #        RightScale dashboard. Only required on EC2 and Eucalyptus.
    # @param secgroup_id [Array] An array of security group IDs to place the
    #        server in.
    #
    # @raise {RightApiProvisionException} if anything
    #         goes wrong
    def provision(servertemplate,
                  server_name = "default",
                  cloud_name = "ec2",
                  deployment_name = "default",
                  inputs = nil,
                  multi_cloud_image_name = nil,
                  ssh_key_uuid = nil,
                  security_groups = nil)

      # fail if the requested cloud is not registered with RightScale account
      @cloud = @api_shim.find_cloud_by_name(cloud_name)
      unless @cloud
        clouds = @client.list_clouds.inject("") { |str, c| str == "" ? c.name : "#{str}, #{c.name}" }
        raise RightScaleError, "ERROR: cannot find a cloud named: '#{cloud_name}'. " +
              "Please check the spelling of the 'cloud_name' parameter in " +
              "your Vagrant file and verify the cloud is registered with " +
              "your RightScale account? Supported clouds: #{clouds}"
      end

      # Verify ssh key uuid, if required by cloud
      if @api_shim.requires_ssh_keys?(@cloud)
        @ssh_key = @api_shim.find_ssh_key_by_uuid_or_first(@cloud, ssh_key_uuid)
        raise "ERROR: cannot find an ssh_key named: #{ssh_key_uuid}" unless @ssh_key
      end

      # Verify security group, if required by cloud
      if @api_shim.requires_security_groups?(@cloud)
        @sec_groups = []
        security_groups ||= ["default"]
        security_groups.each do |name|
          group = @api_shim.find_security_group_by_name(@cloud, name)
          raise "ERROR: cannot find an security group named: #{name}" unless group
          @sec_groups << group
        end
      end

      # check for existing deployment and server in RightScale account
      @deployment = @api_shim.find_deployment_by_name(deployment_name)
      @logger.info "Deployment '#{deployment_name}' #{@deployment ? "found." : "not found."}"
      @server = @api_shim.find_server_by_name(server_name) if @deployment
      @logger.info "Server '#{server_name}' #{@server ? "found." : "not found."}"

      if @server
        # verify existing server is on the cloud we are requesting, if not fail.
        actual_cloud_name = @api_shim.server_cloud_name(@server)
        raise "ERROR: the server is in the '#{actual_cloud_name}' cloud, " +
              "and not in the requested '#{cloud_name}' cloud.\n" +
              "Please delete the server or pick and new server name." if cloud_name != actual_cloud_name
      end

      unless @deployment && @server
        # we need to create a server, can we find the servertemplate?
        begin
          @servertemplate = @client.find_servertemplate(server_template)
        rescue
          raise RightScaleError, "ERROR: cannot find ServerTemplate '#{server_template}'. Did you import it?\n" +
                "Visit http://bit.ly/VnOiA7 for more info.\n\n"
        end

        # We need to find the to be used in the server if the MCI name is given
        begin
          @mci =
            if multi_cloud_image_name.nil? || multi_cloud_image_name.empty?
              nil
            else
              @client.find_mci_by_name(multi_cloud_image_name)
            end
        rescue Exception => e
          raise RightScaleError, "ERROR: Cannot find the mci '#{multi_cloud_image_name}'. Please make sure" +
            " that you have the MCI under the server template selected." +
            " Exception: #{e.inspect}"
        end
      end

      # create deployment and server as needed
      unless @deployment
        @deployment = @api_shim.create_deployment(deployment_name)
        @logger.info "Created deployment."
      end

      unless @server
        @server = @api_shim.create_server(@deployment, @servertemplate, @mci, @cloud, server_name, @ssh_key, @sec_groups)
        @logger.info "Created server."
      end

      unless @api_shim.is_provisioned?(@server)

        # setup any inputs
        begin
          @client.set_server_inputs(@server, inputs) if inputs && ! inputs.empty?
        rescue Exception => e
          raise RightScaleError, "Problem setting inputs. \n #{e.message}\n\n"
        end

        # launch server
        @logger.info "Launching server..."
        @server = @api_shim.launch_server(@server, inputs)
        @api_shim.set_bad_states(BAD_STATES_UP)
        @api_shim.server_wait_for_state(@server, "booting", 30)
      end

    end

    def server_ready?
      @api_shim.server_ready?(@server)
    end

    def wait_for_operational
      @api_shim.set_bad_states(BAD_STATES_UP)
      @api_shim.server_wait_for_state(@server, "operational", 30)
    end

    def server_info
      info = @api_shim.server_info(@server)
      while info.private_ip_addresses.empty?
        @logger.info "Waiting for cloud to provide IP address..."
        sleep 30
        info = @api_shim.server_info(@server)
      end
      info
    end

  end
end
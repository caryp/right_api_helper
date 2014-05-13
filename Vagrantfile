# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load creds from a file
right_api_secrets = YAML.load_file("#{ENV['HOME']}/.right_api_client/login.yml")


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "opscode_ubuntu-12.04_chef-provisionerless"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~/.right_api_client", "/vagrant/.right_api_client"

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "./cookbooks"
    chef.add_recipe "right_api_helper::default"
    chef.add_recipe "right_api_helper::development"
    chef.json = {
      :right_api_helper => {
        :account_id => right_api_secrets[:account_id],
        :user_email => right_api_secrets[:email],
        :user_password => right_api_secrets[:password]
       }
    }
  end

  # tell vagrant-omnibus to install a specific vesion of Chef
  # you will need to install the vagrant-omnibus plugin
  config.omnibus.chef_version = "11.6.0"

  # tell vagrant to use bershelf to pull in cookbook dependencies
  # you will need to install the vagrant-berkshelf plugin
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "./cookbooks/right_api_helper/Berksfile"

end

# RightApiHelper

A collection of helper objects and methods that encapsulate commonly used idioms for [right_api_client](https://github.com/rightscale/right_api_client) users.

## Installation

Add this line to your application's Gemfile:

    gem 'right_api_helper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install right_api_helper

## Usage


### Getting a connection

Get started by creating a [right_api_client](https://github.com/rightscale/right_api_client) handle:

    @client = RightApiHelper::Session.new.create_client("someemail", "somepasswd", "someaccountid", "https://my.rightscale.com")

or

    @client = RightApiHelper::Session.new.create_client_from_file("~/.right_api_client/login.yml")

### Using a helper

Now pass the client handle to a helper object to use it's methods:

    deployment_helper = RightApiHelper::Deployments.new(@client)
    my_deployment = @deployment_helper.find_or_create("My Cool Deployment")

### Logging

By default the helpers log to STDOUT.  But you can modify that by passing a custom `Logger` to each helper.  Here is the example from above modified to use a custom logger.

    my_logger = Logger.new("/tmp/right_api.log)
    deployment_helper = RightApiHelper::Deployments.new(client)
    deployment_helper.logger(my_logger)
    my_deployment = @deployment_helper.find_or_create("My Cool Deployment")

You can also pass a logger object to the `right_api_client` gem. For example:

    session = RightApiHelper::Session.new
    session.logger(my_logger)
    @client = session.create_client_from_file("~/.right_api_client/login.yml")


## TODO

* Need to further sanitize VCR output before including spec/cassettes dir.
* break `lib/right_api_helper/api15.rb` apart into separate helpers?


## Using Vagrant

For local gem development using Vagrant, you must have Vagrant 1.2 or greater installed.  Please see the [vagrant documentation](http://docs.vagrantup.com/v2/) for instructions.  This was tested on Vagrant 1.4.3, so I would start with that.

You will also need to install some gems and the berkshelf and omnibus vagrant plugins.
Here are the commands:

	$ bundle
	$ vagrant plugin install vagrant-berkshelf
	$ vagrant plugin install vagrant-omnibus
	$ vagrant up

Once your instance is launched and configured, ssh in and run the specs

	$ vagrant ssh
	> cd /vagrant
	> bundle
	> bundle exec rake spec


## Contributing

1. Fork it ( https://github.com/caryp/right_api_helper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
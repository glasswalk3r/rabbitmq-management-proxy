# rabbitmq-management-proxy
A Nginx configuration to setup a reverse proxy for RabbitMQ Management plugin

[Rabbitmq](https://www.rabbitmq.com/) has a plugin named [rabbitmq-management](https://www.rabbitmq.com/management.html) that is used to manage by using a HTTP interface.

A side effec to this plugin is to enable some monitoring of the RabbitMQ node (or cluster). There are endpoints available to check the availability from several parts from RabbitMQ.

Unfortunately, the plugin  access control (authorization) is course grained and might expose too much instead of just monitoring endpoints. In order to fix that, it is possible to configure a reverse proxy to be put in front of the RabbitMQ node (or cluster) to control such access.

There are [configuration instructions](https://www.rabbitmq.com/management.html#proxy) about setting up a reverse proxy, but only for Apache webserver. If you want to use Nginx instead, you will find a lot of more difficult: the configuration syntax is not intuitive to follow up and it's really easy to make mistakes.

This project features are:
- forwarding requests to following RabbitMQ HTTP Management API endpoints:
    - /api/nodes
    - /api/aliveness-test
    - /api/queues
- denies any other request to other API endpoints might change the broker configuration and/or state.
- offers a /health itself for monitoring purposes.
- limits the HTTP requests to only GET and HEAD methods.
- templates to generate configuration for Nginx.
- automatic unit tests to validate the RabbitMQ user to provide access to the HTTP management plugin API endpoints (using [RSpec](http://rspec.info/)).
- BDD tests to validate the functional expected behavior (using [Cucumber](https://cucumber.io/)).

## Project status

This project should be treated as beta software. Code may fail, tests probably need a revision.

## Quick intro

To use this project you will need to:

1. Configure a user in the RabbitMQ (see User Management section).
2. Copy all the virtual hosts (vhosts) you have available in the RabbitMQ to the vhosts.txt file.
3. Run the Rspec test to see if the setup is correct for the user created at step 1.
4. Export the configuration of your RabbitMQ node to use in the local environment (copy the JSON file to `test/local/rabbit_config.json`).
5. Run `docker-compose up` to create a copy of your environment.
6. Run the Cucumber BDD tests.

## Configuration steps

1. `git clone` this repository.
2. Edit the app.yaml file. The properties should intuitive enough.
3. Install the project dependencies using [Bundler](https://bundler.io). Use `bundle install --path vendor/bundle` to get the required programs available in your local directory.
4. Run `gencfg.rb` to populate the templates to generate the configuration files for Nginx and the corresponding Dockerfile to generate the Docker image you're going to use for testing and deploy:

```
$ ./gencfg.rb -h
Usage: gencfg [options]
    -e, --environment ENVIRONMENT    the environment to make the deploy (see app.yaml)
```

From that you should have a `tmp` directory with the following files:

```
tmp
├── default.conf
├── Dockerfile
└── nginx.conf
```

In order to generate a container, just `cd` into the `tmp` directory and run `docker build -t rabbitmq-management-proxy` from there.

## User Management

The reverse proxy requires a user added to the RabbitMQ to provide the proper access to the HTTP management plugin.

Thus, you will need to add one with the following (minimal) items:
- give access to all vhosts available in the broker
- for each vhost, include only the following permissions:
    - Configure regexp: aliveness-test
    - Write regexp: amq.default
    - Read regexp: aliveness-test
- given the `monitoring` tag of the HTTP management plugin

Once created, this user configuration can be validated by using the `access_spec.rb` for validation. The login and password must be managed and added to the Nginx configuration file as described in the previous section.

```
$ bundle bin/rspec access_spec.rb

RabbitMQAccess
  #access_nodes?
    can access the /api/nodes endpoint
  #access_queues?
    #access_queues from vhost /sample-vhost
    #access_queues from vhost /sample/complex-vhost
  #check_vhost_alive?
    #check_vhost_alive /sample-vhost
    #check_vhost_alive /sample/complex-vhost

Finished in 0.03879 seconds (files took 0.12732 seconds to load)
5 examples, 0 failures
```

The currently implementation of `access_spec.rb` uses http://localhost:15672 to connect to and run the validations. You will want to edit the `vhosts.txt` to add all the vhosts you want to monitor from RabbitMQ.

## BDD

This project includes BDD tests so you can keep your configuration documented and properly tested.

Beware that these tests uses Docker Compose and expect that the reverse proxy container image was generate with the name `rabbitmq-management-proxy`. You can, of course, update the `docker-compose.yml` file with the right value, or generate a Docker image with the expected name.

In order to run the tests, execute:

```
cd tests\local
docker-compose up
```

Then, in another shell:

```
cd tests
bundle exec cucumber -f pretty
```

There are other options for the `-f` option of the cucumber program. You might want to check the documentation for it to see the available formats.

## Tested environment

This project was tested on the following environment:
- Linux Ubuntu 16.04
- Ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
- Bundler 1.11.2

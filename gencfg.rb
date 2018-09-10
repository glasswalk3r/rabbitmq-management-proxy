#!/usr/bin/ruby
require 'optparse'
require 'ostruct'
require 'erb'
require 'yaml'
require 'base64'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-e', '--environment ENVIRONMENT', 'the environment to make the deploy (see app.yaml)') { |o| options.env = o }
end.parse!
raise OptionParser::MissingArgument.new('-e is required') if options.env.nil?
config = YAML.load_file('app.yaml')

unless config['environments'].has_key?(options.env)
    raise KeyError.new("There is no such environment called '#{options.env}' in the YAML configuration file")
end

temp_dir = './tmp'

Dir.mkdir(temp_dir) unless File.exists?(temp_dir)

File.open("#{temp_dir}/nginx.conf", 'w') do |f|
    renderer = ERB.new(File.read('templates/nginx.conf.erb'), 0, '>')
    f.write(renderer.result(binding))
end

File.open("#{temp_dir}/Dockerfile", 'w') do |f|
    renderer = ERB.new(File.read('templates/Dockerfile.erb'), 0, '>')
    f.write(renderer.result(binding))
end

user = config['environments'][options.env]['rabbitmq']['user']
password = config['environments'][options.env]['rabbitmq']['password']
basic_auth = Base64.strict_encode64("#{user}:#{password}")

File.open("#{temp_dir}/default.conf", 'w') do |f|
    renderer = ERB.new(File.read('templates/default.conf.erb'), 0, '>')
    f.write(renderer.result(binding))
end

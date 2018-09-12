require 'net/http'
require 'rabbitmq_access'

describe RabbitMQAccess do
    before do
        @host = 'localhost'
        @port = '15672'
        @checker = RabbitMQAccess.new()
    end

    context '#access_nodes?' do
        it 'can access the /api/nodes endpoint' do
            expect {@checker.access_nodes(@host, @port)}.to_not raise_error
        end
    end

    # reading twice from the text file due the way Rspec organizes the output with "-f d" option
    context '#access_queues?' do
        File.open('vhosts.txt', 'r') do |fh|
            fh.each_line do |vhost|
                it "#access_queues from vhost #{vhost}" do
                    expect {@checker.check_endpoint_with_vhost(@host, @port, '/api/queues/', vhost.chomp)}.to_not raise_error
                end
            end
        end
    end
    context '#check_vhost_alive?' do
        File.open('vhosts.txt', 'r') do |fh|
            fh.each_line do |vhost|
                it "#check_vhost_alive #{vhost}" do
                    expect {@checker.check_endpoint_with_vhost(@host, @port, '/api/aliveness-test/', vhost.chomp)}.to_not raise_error
                end
            end
        end
    end
end

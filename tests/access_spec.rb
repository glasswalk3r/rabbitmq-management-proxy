require 'net/http'


class RabbitMQAccess
    def initialize
        @user = 'rabbit_mon'
        @password = 'a_local_weak_password'
    end

    def access_nodes(host, port)
        uri = URI("http://#{host}:#{port}/api/nodes")
        req = Net::HTTP::Get.new(uri)
        req.basic_auth @user, @password

        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
        }

        res.value
    end

    def check_endpoint_with_vhost(host, port, path, vhost)
        # make sureh that path begins and ends with a slash!
        uri = URI("http://#{host}:#{port}#{path}#{vhost.gsub('/', '%2f')}")
        req = Net::HTTP::Get.new(uri)
        req.basic_auth @user, @password

        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
        }

        res.value
    end
end

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

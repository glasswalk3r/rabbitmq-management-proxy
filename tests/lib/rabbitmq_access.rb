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

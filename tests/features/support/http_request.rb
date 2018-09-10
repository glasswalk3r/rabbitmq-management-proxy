module HTTPRequest
    def rabbitmq_vhost_http_request(url, endpoint, vhost)
        uri = URI(url + endpoint + '/' + vhost.gsub('/', '%2f'))
        req = Net::HTTP::Get.new(uri)
        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
        }
        return res
    end

    def rabbitmq_http_request(url, endpoint)
        uri = URI(url + endpoint)
        req = Net::HTTP::Get.new(uri)
        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
        }
        return res
    end
end

World(HTTPRequest)

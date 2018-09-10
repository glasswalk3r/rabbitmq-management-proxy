require 'net/http'
require 'json'

Given /the reverse proxy is located at (http:\/\/[\w\/:]+)/ do |url|
    @url = url
end

When /HTTP request is made to ([\/\w\-]+) with any simple vhost$/ do |endpoint|
    candidate = random_vhost
    @result = rabbitmq_vhost_http_request(@url, endpoint, candidate)
end

When /HTTP request is made to ([\/\w\-]+) with any complex vhost$/ do |endpoint|
    candidate = random_vhost
    @result = rabbitmq_vhost_http_request(@url, endpoint, candidate)
end

When /HTTP GET request is made to ([\w\/]+)$/ do |endpoint|
    @result = rabbitmq_http_request(@url, endpoint)
end

Then /^a HTTP (\d+) response will be received$/ do |http_code|
    expect(@result.code).to eq(http_code.to_s)
end

And /the response type should be (\w+)$/ do |response_type|
    # application/json
    expected = 'application/' + response_type.downcase
    expect(@result['Content-Type']).to eq(expected)
end

And /the JSON structure represents queues/ do
    body = JSON.parse(@result.body)
    expect(body).to be_a(Array)
    expect(body.size).to be >= 1
    expect(body[0]).to be_a(Hash)
    minimum = [:vhost, :name, :messages, :state, :consumers]
    minimum.each do |expected_key|
        expect(body[0].has_key?(expected_key))
    end
end

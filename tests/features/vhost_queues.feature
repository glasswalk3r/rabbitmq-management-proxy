# language: en
Feature: verify the associated queues within a specific virtual host at RabbitMQ

    To be able to check the associated queues status of a specific virtual host at a RabbitMQ
    As an application that depends on it
    I want to access the corresponding endpoint of those queues

    Background:
        Given the reverse proxy is located at http://localhost:8080

    Scenario: check the queues status of a simple virtual host from the reverse proxy
        Accessing /api/aliveness-test at the reverse proxy using as parameter a simple vhost name (one with a single slash at the beginning) a successful message is received

        When a HTTP request is made to /api/queues with any simple vhost
        Then a HTTP 200 response will be received
        And the response type should be JSON
        And the JSON structure represents queues

    Scenario: check the queues status of a complex virtual host from the reverse proxy
        Accessing /api/aliveness-test at the reverse proxy using as parameter a complex vhost name (one with multiple slashes) a successful message is received

        When a HTTP request is made to /api/queues with any complex vhost
        Then a HTTP 200 response will be received
        And the response type should be JSON
        And the JSON structure represents queues

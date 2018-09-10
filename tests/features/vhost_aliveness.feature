# language: en
Feature: check the availability of virtual hosts on RabbitMQ

    To be able to check the availability of a specific virtual host on RabbitMQ
    As an application that depends on it
    I want to access the corresponding endpoint of it to check the related status

    Background:
        Given the reverse proxy is located at http://localhost:8080

    Scenario: validate the aliveness of a simple vhost from the reverse proxy
        Accessing /api/aliveness-test at the reverse proxy using as parameter a simple vhost name (one with a single slash at the beginning) a successful message is received

        When a HTTP request is made to /api/aliveness-test with any simple vhost
        Then a HTTP 200 response will be received
        And the response type should be JSON

    Scenario: validate the aliveness of a complex vhost from the reverse proxy
        Accessing /api/aliveness-test at the reverse proxy using as parameter a complex vhost name (one with multiple slashes) a successful message is received

        When a HTTP request is made to /api/aliveness-test with any complex vhost
        Then a HTTP 200 response will be received
        And the response type should be JSON

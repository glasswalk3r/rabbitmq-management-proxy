# language: en
Feature: check the reverse proxy health

    To ensure the proper functioning of the proxy
    As a monitoring application
    I want to check the health endpoint of it

    Scenario: the reverse proxy is healthy
        If a request is made to the /health endpoing of the reverse proxy, a success message is received.

        Given the reverse proxy is located at http://localhost:8080
        When a HTTP GET request is made to /health
        Then a HTTP 200 response will be received

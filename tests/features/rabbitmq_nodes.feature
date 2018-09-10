# language: en
Feature: get all available nodes in RabbitMQ

    To be able to check the RabbitMQ cluster health
    As an application that relies on it
    I want to verify the corresponding endpoint of it

    Scenario: we can query the nodes via the reverse proxy
        Accessing the endpoint /api/nodes of the reverse proxy, we receive a successful message with the corresponding data of the nodes

        Given the reverse proxy is located at http://localhost:8080
        When a HTTP GET request is made to /api/nodes
        Then a HTTP 200 response will be received
        And the response type should be JSON

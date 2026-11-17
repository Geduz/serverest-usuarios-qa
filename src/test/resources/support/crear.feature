@ignore
Feature: Crear usuario de prueba

  Scenario:
    Given url baseUrl
    And path 'usuarios'
    And request __arg.datos
    When method post
    * def id = responseStatus == 201 ? response._id : null

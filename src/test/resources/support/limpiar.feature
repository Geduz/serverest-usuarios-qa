@ignore
Feature: Retirar usuario de prueba

  Scenario:
    Given url baseUrl
    And path 'usuarios', __arg.id
    When method delete
    Then status 200
    And match ['Registro excluído com sucesso', 'Nenhum registro excluído'] contains response.message

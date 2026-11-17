Feature: DELETE /usuarios/{id}

  Background:
    * url baseUrl
    * def nuevo = read('classpath:support/usuario.js')
    * def esquemas = read('classpath:support/esquemas.json')
    * def limpieza = []
    * configure afterScenario = function(){ karate.get('limpieza', []).forEach(function(id){ karate.call('classpath:support/limpiar.feature', { id: id }); }); }

  @positivo
  Scenario: Eliminar un usuario creado por la prueba
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    Given path 'usuarios', alta.id
    When method delete
    Then status 200
    And match response == esquemas.eliminado
    Given path 'usuarios', alta.id
    When method get
    Then status 400
    And match response == esquemas.ausente

  @negativo
  Scenario: Repetir el borrado de un usuario que ya no existe
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    Given path 'usuarios', alta.id
    When method delete
    Then status 200
    And match response == esquemas.eliminado
    Given path 'usuarios', alta.id
    When method delete
    Then status 200
    And match response == esquemas.sinRegistro

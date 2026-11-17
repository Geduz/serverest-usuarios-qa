Feature: GET /usuarios/{id}

  Background:
    * url baseUrl
    * def nuevo = read('classpath:support/usuario.js')
    * def esquemas = read('classpath:support/esquemas.json')
    * def limpieza = []
    * configure afterScenario = function(){ karate.get('limpieza', []).forEach(function(id){ karate.call('classpath:support/limpiar.feature', { id: id }); }); }

  @positivo
  Scenario: Buscar un usuario por su identificador
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    Given path 'usuarios', alta.id
    When method get
    Then status 200
    And match response == esquemas.usuario
    * set datos._id = alta.id
    And match response == datos

  @negativo
  Scenario: Buscar un identificador inexistente
    * def idAusente = Java.type('java.util.UUID').randomUUID().toString().replace(/-/g, '').slice(0, 16)
    Given path 'usuarios', idAusente
    When method get
    Then status 400
    And match response == esquemas.ausente

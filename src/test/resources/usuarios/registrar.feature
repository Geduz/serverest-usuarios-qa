Feature: POST /usuarios

  Background:
    * url baseUrl
    * def nuevo = read('classpath:support/usuario.js')
    * def esquemas = read('classpath:support/esquemas.json')
    * def limpieza = []
    * configure afterScenario = function(){ karate.get('limpieza', []).forEach(function(id){ karate.call('classpath:support/limpiar.feature', { id: id }); }); }

  @positivo
  Scenario: Registrar y recuperar el usuario con los valores enviados
    * def datos = nuevo()
    Given path 'usuarios'
    And request datos
    When method post
    * def id = responseStatus == 201 ? response._id : null
    * if (id) limpieza.push(id)
    Then status 201
    And match response == esquemas.creado
    Given path 'usuarios', id
    When method get
    Then status 200
    * set datos._id = id
    And match response == datos

  @negativo
  Scenario: Rechazar un correo duplicado
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    Given path 'usuarios'
    And request datos
    When method post
    * if (responseStatus == 201 && response._id) limpieza.push(response._id)
    Then status 400
    And match response == esquemas.duplicado

  @negativo
  Scenario: Rechazar un correo mal formado
    * def datos = nuevo()
    * set datos.email = 'correo-invalido'
    Given path 'usuarios'
    And request datos
    When method post
    * if (responseStatus == 201 && response._id) limpieza.push(response._id)
    Then status 400
    And match response == esquemas.emailInvalido

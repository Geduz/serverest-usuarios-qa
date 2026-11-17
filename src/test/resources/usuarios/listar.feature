Feature: GET /usuarios

  Background:
    * url baseUrl
    * def nuevo = read('classpath:support/usuario.js')
    * def esquemas = read('classpath:support/esquemas.json')
    * def limpieza = []
    * configure afterScenario = function(){ karate.get('limpieza', []).forEach(function(id){ karate.call('classpath:support/limpiar.feature', { id: id }); }); }

  @positivo
  Scenario: Listar usuarios e incluir el usuario recién registrado
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    Given path 'usuarios'
    When method get
    Then status 200
    And match response contains { quantidade: '#number', usuarios: '#array' }
    And match response.quantidade == response.usuarios.length
    And match each response.usuarios == esquemas.usuario
    And match response.usuarios contains deep { _id: '#(alta.id)', email: '#(datos.email)' }

  @negativo
  Scenario: Filtrar por un correo inexistente
    Given path 'usuarios'
    And param email = nuevo().email
    When method get
    Then status 200
    And match response == { quantidade: 0, usuarios: [] }

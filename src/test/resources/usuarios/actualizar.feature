Feature: PUT /usuarios/{id}

  Background:
    * url baseUrl
    * def nuevo = read('classpath:support/usuario.js')
    * def esquemas = read('classpath:support/esquemas.json')
    * def limpieza = []
    * configure afterScenario = function(){ karate.get('limpieza', []).forEach(function(id){ karate.call('classpath:support/limpiar.feature', { id: id }); }); }

  @positivo
  Scenario: Actualizar los datos y conservar el identificador
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    * def cambios = nuevo()
    * set cambios.nome = 'QA Karate editado'
    * set cambios.administrador = 'true'
    Given path 'usuarios', alta.id
    And request cambios
    When method put
    Then status 200
    And match response == esquemas.actualizado
    Given path 'usuarios', alta.id
    When method get
    Then status 200
    And match response == esquemas.usuario
    * set cambios._id = alta.id
    And match response == cambios

  @negativo
  Scenario: Rechazar un correo usado por otro usuario y conservar los datos originales
    * def datos = nuevo()
    * def alta = call read('classpath:support/crear.feature') { datos: '#(datos)' }
    * if (alta.id) limpieza.push(alta.id)
    * match alta.responseStatus == 201
    * match alta.response == esquemas.creado
    * def otro = nuevo()
    * def segundaAlta = call read('classpath:support/crear.feature') { datos: '#(otro)' }
    * if (segundaAlta.id) limpieza.push(segundaAlta.id)
    * match segundaAlta.responseStatus == 201
    * match segundaAlta.response == esquemas.creado
    * def cambios = nuevo()
    * set cambios.email = otro.email
    Given path 'usuarios', alta.id
    And request cambios
    When method put
    Then status 400
    And match response == esquemas.duplicado
    Given path 'usuarios', alta.id
    When method get
    Then status 200
    And match response == esquemas.usuario
    * set datos._id = alta.id
    And match response == datos

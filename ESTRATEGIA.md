# Estrategia de automatización

| Operación | Caso positivo | Caso negativo o alternativo |
| --- | --- | --- |
| GET /usuarios | 200, lista con el usuario creado y cantidad coherente | 200, filtro por correo inexistente devuelve lista vacía |
| POST /usuarios | 201, alta y lectura posterior con los valores enviados | 400 por correo duplicado y 400 por correo mal formado |
| GET /usuarios/{id} | 200, ID y valores del usuario solicitado | 400 para un ID inexistente |
| PUT /usuarios/{id} | 200, valores persistidos e ID conservado | 400 por correo en uso y lectura posterior de los valores originales |
| DELETE /usuarios/{id} | 200 y lectura posterior con 400 | 200 al repetir el borrado, con mensaje de que no se eliminó ningún registro |

Los 11 escenarios usan Given, When y Then para expresar el comportamiento. Los esquemas reutilizables de Karate validan estructura, tipos y mensajes del contrato. Las lecturas posteriores comprueban persistencia y distinguen una respuesta de éxito de un cambio efectivo de estado.

Cada escenario que modifica datos genera sus propios usuarios mediante un UUID. Los helpers reutilizan el alta y la baja, y `afterScenario` retira los IDs devueltos por las altas exitosas, incluso cuando fallan aserciones posteriores. Las búsquedas de registros inexistentes emplean identificadores aleatorios para evitar depender del contenido de la base compartida. Para ejecuciones repetibles se puede apuntar a una instancia local con `baseUrl`.

La cobertura se concentra en Usuarios y en las reglas de validación, unicidad y existencia. El borrado de un usuario con carrito requiere datos de otro recurso y queda fuera de esta matriz.

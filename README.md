# Automatización QA de Usuarios en ServeRest

Suite de Karate DSL 1.5.1 con JUnit 5. Requiere JDK 17 o superior, Maven 3.9 y acceso a Maven Central durante la primera compilación.

Desde la raíz del proyecto:

```shell
java -version
mvn -version
mvn clean test
```

La URL predeterminada es https://serverest.dev. Para usar una instancia local de ServeRest o ejecutar solo una categoría:

```shell
mvn "-DbaseUrl=http://localhost:3000" test
mvn '-Dkarate.options=--tags @negativo' test
```

Karate escribe el informe en `target/karate-reports/karate-summary.html` y Maven genera los resultados de JUnit en `target/surefire-reports/`.

- `src/test/resources/usuarios/` contiene un feature por endpoint.
- `src/test/resources/support/` reúne datos, esquemas y operaciones de preparación y limpieza.
- [ESTRATEGIA.md](ESTRATEGIA.md) documenta la matriz de cobertura y las decisiones de diseño.
- [Contrato de ServeRest](https://serverest.dev/swagger.json).

---
title: API-first development with Quarkus
---

When designing an API one of the first question you need to answer is who is the user of the API and how does an API solves his problems.
Once you defined your use case though, you need to define the API itself. One way to tackle the problem is to start coding the solution and rely on a library or tool to extract the API from the realized service. This approach is conventionally called "code first", meaning you first code the solution and then extract a formal definition of the API. Typical API definitions are OpenAPI, WSDL, or GraphQL.

## API-first

According to [Zalando's REST API design guide](https://opensource.zalando.com/restful-api-guidelines/#100) and [Thoughtworks tech radar](https://www.thoughtworks.com/radar), however, the preferred way to design an API is with an "API-first" approach.
The API-first approach inverts the order of operations, meaning you first design your API directly in the formal definition, and then you code the service that serves the API (pun not intended).

This approach makes sure that one can develop server, clients, and tests all at once, since they all starts with the same specification. 

This is what an API is: the API is the product, the documentation and the formal definition is their User Interface, the error codes and mode of interactions are the User Experience.

But how do we do it? Let's see what tools we have in the Java world.

## API-first quarkus server

Suppose we have already defined an API in the form of OpenAPI. For simplicity and ease of comparison, we use the classic example: the pet store. We gather the OpenAPI specification from their [OpenAPI sample catalog](https://github.com/OAI/OpenAPI-Specification/tree/main/examples/v3.0) ([direct link to OpenAPI spec](https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore.json)), and then we need to generate the base code for our server.
We have multiple options here:
- if we are designing a server for a fixed API we may want to generate the project skeleton once and probably edit the generated files directly
- if on the other hand we are currenty developing the API itself or we want to promptly fail the build when we change the API, we should generate only standard beans and service interfaces.

What we will do for this example is the latter approach, and we will use two handy tools:
- OpenAPI official Java code generator tool and maven plugin
- quarkus framework for developing fast cloud-native applications

Let's start!

First, we assume we have the quarkus cli installed (use the great [SDKMAN!](https://sdkman.io/) if you want an easy install) and we start with a 
```bash
$ quarkus create app pro.robertopiva:api-first-pet-store \
    --extension=resteasy-reactive-jackson,hibernate-validator
$ cd api-first-pet-store
```
You can then remove the sample code and tests since we will replace them with generated code.
Then we want to download the OpenAPI spec for ease of use.
```bash
$ curl https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore-expanded.json -o petstore.openapi.json
## for a fancier version:
$ curl https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore-expanded.json | jq > petstore.openapi.json
```
And now we need a way to generate the rest interfaces and the java beans, so we configure the [OpenAPI maven generator plugin](https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator-maven-plugin). The plugin itself is very general, and can be used in a variety of contexts. Generator classes are all listed in [https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator/src/main/java/org/openapitools/codegen/languages](https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator/src/main/java/org/openapitools/codegen/languages) and configuration variables are also listed in [https://openapi-generator.tech/docs/generators/java](https://openapi-generator.tech/docs/generators/java).

For our case we will use:
- jaxrs-spec generator (JavaJAXRSSpecServerCodegen) to generate only the java REST interfaces
- of course generate models (java beans)
- java 8-compatible dates
- skip generation of swagger annotations (we start from openapi spec after all)
- also skip supporting files (maven project), generated tests, generated documentation
- skip authentication-related files

The corresponding maven plugin XML is written below:

```xml
<plugin>
    <groupId>org.openapitools</groupId>
    <artifactId>openapi-generator-maven-plugin</artifactId>
    <version>6.0.1</version>
    <executions>
        <execution>
        <goals>
            <goal>generate</goal>
        </goals>
        <configuration>
            <inputSpec>${project.basedir}/petstore.openapi.json</inputSpec>
            <generatorName>jaxrs-spec</generatorName>
            <configOptions>
            <dateLibrary>java8</dateLibrary>
            <useSwaggerAnnotations>false</useSwaggerAnnotations>
            <!--ensure we only generate java interfaces and no implementation skeleton-->
            <interfaceOnly>true</interfaceOnly>
            </configOptions>
            <apiPackage>pro.robertopiva.api</apiPackage>
            <modelPackage>pro.robertopiva.beans</modelPackage>
            <generateModelTests>false</generateModelTests>
            <generateModelDocumentation>false</generateModelDocumentation>
            <generateSupportingFiles>false</generateSupportingFiles>
            <generateApiTests>false</generateApiTests>
            <generateApiDocumentation>false</generateApiDocumentation>
            <auth>false</auth>
        </configuration>
        </execution>
    </executions>
</plugin>
<!--maven helper plugin to add generated sources to maven project-->
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>build-helper-maven-plugin</artifactId>
    <executions>
        <execution>
        <phase>generate-sources</phase>
        <goals>
            <goal>add-source</goal>
        </goals>
        <configuration>
            <sources>
            <source>${project.build.directory}/generated-sources/openapi/src/gen/java</source>
            </sources>
        </configuration>
        </execution>
    </executions>
</plugin>
```

After running the canonical `./mvnw clean package` we should have:
```bash
$ exa --tree target
target
├── [...]
├── generated-sources
│  ├── annotations
│  └── openapi
│     └── src
│        └── gen
│           └── java
│              └── pro
│                 └── robertopiva
│                    ├── api
│                    │  └── PetsApi.java
│                    └── beans
│                       ├── Error.java
│                       ├── NewPet.java
│                       ├── Pet.java
│                       └── PetAllOf.java
[...]
```

We can clearly see that the plugin generated beans and interfaces.

What now? We implement those interfaces!

On our `src/main/java` folder we can now implement `PetsApi` interface in our new class.

See here a snippet without implementation:
```java
public class Pets implements PetsApi {

    @Override
    public Pet addPet(@Valid @NotNull NewPet newPet) {
        return null;
    }

    @Override
    public void deletePet(Long id) {
    }

    @Override
    public Pet findPetById(Long id) {
        return null;
    }

    @Override
    public List<Pet> findPets(List<String> tags, Integer limit) {
        return null;
    }
}
```
Please note that this class is not part of the generated code, we specifically skipped the generation of "basic implementation".
As we can see, with the interface being already set in generation, we can focus on the implementation rather than on the definitions.

You can see a quick in-memory implementation of PetsApi at https://github.com/civitz/quarkus-api-first/blob/main/src/main/java/pro/robertopiva/api/Pets.java 

## Changing the API

Another benefit of the API-first approach is that to change the API we need to first change it's documentation, i.e. the OpenAPI spec.

To do this, we try to add another optional parameter to the findPets API and see what happens.
If we add the following json snippet:
```json
// last parameter
{
    "name": "limit",
    "in": "query",
    "description": "maximum number of results to return",
    "required": false,
    "schema": {
        "type": "integer",
        "format": "int32"
    }
},
// added optional parameter
{
    "name": "page",
    "in": "query",
    "description": "page number (max 'limit' items per page')",
    "required": false,
    "schema": {
        "type": "integer",
        "format": "int32"
    }
}
```

Once we compile with `./mvnw clean package` we obtain:
```
[INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ api-first-pet-store ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 6 source files to /workspace/api-first-pet-store/target/classes
[INFO] -------------------------------------------------------------
[ERROR] COMPILATION ERROR : 
[INFO] -------------------------------------------------------------
[ERROR] /workspace/api-first-pet-store/src/main/java/pro/robertopiva/api/Pets.java:[18,8] pro.robertopiva.api.Pets is not abstract and does not override abstract method findPets(java.util.List<java.lang.String>,java.lang.Integer,java.lang.Integer) in pro.robertopiva.api.PetsApi
[ERROR] /workspace/api-first-pet-store/src/main/java/pro/robertopiva/api/Pets.java:[49,5] method does not override or implement a method from a supertype
[INFO] 2 errors 
[INFO] -------------------------------------------------------------
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
```

This is beneficial for any situation where you want to be sure that the code respect the contract, i.e. the API. 

## Bonus: native compilation

We are using quarkus and we are not adding any incompatible dependency, so we can also compile to native code using the specific maven profile: `./mvnw clean package -Pnative`.

Once compiled, our API-first project boots in microseconds:
```
$ ./target/api-first-pet-store-1.0.0-SNAPSHOT-runner 
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \   
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/   
2022-08-06 19:29:06,858 INFO  [io.quarkus] (main) api-first-pet-store 1.0.0-SNAPSHOT native (powered by Quarkus 2.11.1.Final) started in 0.025s. Listening on: http://0.0.0.0:8080
2022-08-06 19:29:06,861 INFO  [io.quarkus] (main) Profile prod activated. 
2022-08-06 19:29:06,861 INFO  [io.quarkus] (main) Installed features: [cdi, hibernate-validator, resteasy-reactive, resteasy-reactive-jackson, smallrye-context-propagation, vertx]
```

## Concusions

Some companies are organized so that API clients are automatically, and fully, generated from OpenAPI spec. This facilitate integration both within and outside the company: **documenting the API is part of the development process**.

The Quarkus framework and OpenAPI generator enable an API-first approach while simultaneously maintaining high performances and native compilation as a bonus.

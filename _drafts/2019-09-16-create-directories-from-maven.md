---
published: false
---
## Creating directories from maven

I was working with a library which generates code from a template. To avoid committing the generated code I used a maven plugin, so I can commit the template, and generate the code at compile-time.

The plugin failed to do its work if the target directory was not already created, which is ironic given the library accepts the target path as parameter.

So the quest was to create the directory beforehand, and let the plugin do the job.

This is the snippet that solves the problem:
```xml
<plugin>
    <artifactId>maven-antrun-plugin</artifactId>
    <version>1.8</version>
    <executions>
        <execution>
            <phase>initialize</phase>
            <configuration>
                <target>
                    <mkdir dir="${project.build.directory}/generated-sources/mydir/my/cute/package" />
                </target>
            </configuration>
            <goals>
                <goal>run</goal>
            </goals>
        </execution>
    </executions>
</plugin>
<plugin>
    <!-- the code-generation plugin goes here -->
</plugin>
```

This solution uses `antrun` to execute an ant command that creates the directory. This is preferable to a maven exec plugin since it is platform-agnostic. The `initialize` phase is used to run the plugin before the `generate-sources` phase.

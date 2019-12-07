
# Cucumber | Aruba | Behavior Driven Development



## Executing Cucumber Feature Files in Subdirectories

Often it makes more sense to place **`cucumber feature files`** into code directories. Plugin development depends on all aspects of the plugin including code, configuration and tests situated in its own directory tree.

```
$ cucumber                       # by default searches the features directory
$ cucumber path/to/parent/folder # recursively searches for *.feature files
```

## Aruba | The support directory

If you want to use **`aruba`** and other *support* code you must include (require) it.

By default cucumber scans and imports (requires in ruby) any **`*.rb`** files below the **`features/support`** or any **`*/support`** path under the specified feature directories.

```
cucumber path/to/parent/folder --require path/to/ruby/files/to/require
```

Note that the --require option switches off automatic loading and everything loaded must be specified.

## More Excellent Cucumber Resources

These are links to excellent resources on behavioural driven development (BDD) with Cucumber (and Aruba).

- **[Cucumber Ruby Web Testing using Watir](https://www.guru99.com/your-first-cucumber-script.html)**
- **[Crate a Java Cucumber project with Maven Archetypes in IntelliJ](https://cucumber.io/docs/guides/10-minute-tutorial/)**
- **[Selinium Firefox and Cucumber web testing using Java and Maven](https://automationrhapsody.com/introduction-to-cucumber-and-bdd-with-examples/)**
- **[Jenkins CI Cucumber Reports Plugin](https://github.com/jenkinsci/cucumber-reports-plugin)**

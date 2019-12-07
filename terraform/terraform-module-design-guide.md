
# Terraform Module Design Guidelines

High quality modules engender reuse so must not contain hardcoded environment specific data.

A high quality terraform module

- is region agnostic
- is availability zone agnostic

See page **[[terraform hardcode aws ids]]** to avoid hardcoding AWS Regions, Ubuntu AMIs, CoreOS AMIs, Availability Zones and more.


## AWS Region Agnostic

A hardcoded region like **eu-central-1** must never appear anywhere in the terraform files or input variables.

The only place the region is set is within the AWS_REGION key alongside the IAM user configuration which is typcially found in environment variables (in the shell the terraform commands are run).


## The Ubiquitous Stamp

The timestamp enables

- two or more developers to run tests in parallel in the same environment without a clash of IDs
- one developer to run the tests in different shells without sequential destroys
- us to find and examine the infrastructure relevant to our test run (through the console)

We need to better this and be able to mark infrastructure belonging to test cases as such. Also to mark infrastructure with names so that multiple developers know "who" created this here infrastructure, when and for what.

## Variable Naming Convention

- in_ for input variables
- out_ for output variables

## Naming Boolean Variables

    in_is_blue
    in_is_green
    in_is_lightweight
    in_is_heavy_duty

Prefix it with is_ or has_

Avoid using "negator" variables.

Prefer "in_is_late" to "in_is_not_early"

## Module Names | Declaration

Prefer module names with neither hyphens nor underscores.

## Module Names | Usage

Modules are renamed when you use them.
Definitely you should end with _module.
Preferably you can add underscores.

## Module Dependency

Try to write modules that **do not depend** on other modules.

Terraform hasn't yet got the rigour of an object oriented language with dependency management tools like Maven, RubyGems, Gradle and Python Wheels. Nor does it have fully featured IDE support that makes traversing dependencies a breeze.

## Module Development | IDE

When writing modules IDE support brings significant productivity gains and enables visualization of different aspects of Terraform declarative HCL platform. Taking time out to integrate with one, pays.

As of now the only Terraform IDE of note is a plugin into the JetBrain suite of IDE's. You can import the Terraform plugin into

- **IntelliJ** (for Java Developers)
- **RubyMine** (for Ruby Developers)
- **PyCharm** (for Python Developers)

HashiCorp is taking steps to partner with one or two other IDE shops but as of yet no announcements have been made.


## Module Tests and Continuous Integration

Terraform (HCL) is declarative, but it is still software. When writing modules all the best practise still applies like

- writing (unit) tests (with scope limited to one module)
- using behaviour driven development (Cucumber)
- using source control with semantic versioned tags
- continuous integration via CircleCI, Jenkins, CodeShip or TravisCI
- writing multi-module integration tests and using Inspec and/or Chef's Kitchen


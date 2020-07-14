# sfdx-cli@7.65.2 bug when pushing source to scratch-org

This repo demostrates a regression error introduced in sfdx-cli version 7.65.2 by which we cannot push the source to a scratch org when:

* We have two packages, A and B
* Package A defines a custom object e.g. `Fruit__c`
* Package B defines a custom object e.g. `Apple__c`
* Package B has a field that references to an object in Package A
  * `Apple__c` has a field `Fruit__c` which is a reference to `Fruit__c` object

```sh
$ sfdx force:source:push
Job ID | 0AfR0000012gEM2KAM
SOURCE PROGRESS | ████████████████████░░░░░░░░░░░░░░░░░░░░ | 1/2 Components
TYPE   PROJECT PATH                                                            PROBLEM
─────  ──────────────────────────────────────────────────────────────────────  ─────────────────────────────────────────────────────────────────────────────────
Error  package-b/main/default/objects/Apple__c/fields/Fruit__c.field-meta.xml  referenceTo value of 'Fruit__c' does not resolve to a valid sObject type (166:13)
ERROR running force:source:push:  Push failed.

Try this:
Check the order of your dependencies and ensure all metadata is included.
```

**This error was introduced in sfdx-cli version 7.65.2. Works fine in sfdx-cli version 7.63.0**.


I've added a sfdx project file with two packages, `package_a` and `package_b`

```
$ tree package-a package-b
package-a
└── main
    └── default
        └── objects
            └── Fruit__c
                ├── Fruit__c.object-meta.xml
                └── fields
                    └── Color__c.field-meta.xml
package-b
└── main
    └── default
        └── objects
            └── Apple__c
                ├── Apple__c.object-meta.xml
                └── fields
                    └── Fruit__c.field-meta.xml    <--- references to package-a's `Fruit__c` custom object

10 directories, 4 files
```

## Make it fail 

Pre-requisite:
* UNIX like OS
* Node v12.14.0

I've added a custom bash script to reproduce the error. This scripts does the following things:

1. Installs sfdx-cli@7.63.0 npm package version
2. Logs you in to your dev hub
3. Creates a new scratch org
4. Push the source code to the scratch org
5. Works fine

Then it does the same with the buggy version 

1. Installs sfdx-cli@7.65.2 npm package version
2. Logs you in to your dev hub
3. Creates a new scratch org
4. Push the source code to the scratch org
5. Push fails with the error described above

Usage:

```
$ ./run.sh https://<dev-hub>.my.salesforce.com
```

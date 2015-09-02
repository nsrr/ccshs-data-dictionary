CCSHS Data Dictionary
========================

[![Build Status](https://travis-ci.org/sleepepi/ccshs-data-dictionary.svg?branch=master)](https://travis-ci.org/sleepepi/ccshs-data-dictionary)

The Cleveland Children's Sleep and Health Study Data Dictionary is an
asynchronous, multi-user curated JSON dictionary using Git for version control.

### Exports

The data dictionary can be exported to CSV by typing the following command:

```
spout export
```

The `spout export` command will generate two CSV files, one that concatentates
all the variables together into a CSV file, and another file that concatenates
all of the domains.


### Testing

The CCSHS Data Dictionary is tested using the
[Spout Gem](https://github.com/sleepepi/spout). In order to validate various
aspects of the variables and domains, a user can run the following command:

```
spout test
```


### Releases

The Data Dictionary is tagged at various time points using
[Git tags](http://git-scm.com/book/en/Git-Basics-Tagging). The tags are used to
reference a series of SQL files that correspond to the data dictionary itself.

For example, SQL files of the underlying data that have been tagged as `v0.1.0`
will be compatible with the CCSHS Data Dictionary `~> 0.1.0`, (including
`0.1.1`, `0.1.2`, `0.1.3`). However if the data dictionary contains changes to
the underlying dataset, then the minor version number is bumped, and the patch
level is reset to zero. If, for example, the SQL dataset changed to `v0.2.0`,
then it would be compatible with `0.2.0`, `0.2.1`, `0.2.2`, etc. The approach
for changing version numbers uses a variation on
[Semantic Versioning](http://semver.org).

A full list of changes for each version can be viewed in the
[CHANGELOG](https://github.com/sleepepi/ccshs-data-dictionary/blob/master/CHANGELOG.md).

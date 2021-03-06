# Semantic Versioning

Semantic versioning plugin for Erlang.mk.



### Overview

When added to a project, it automatically defines `PROJECT_VERSION` variable
with a value in [SemVer][semver] format extracted from Git. A complete version
string will be formated according the following rules and order priority:
- If at least one Git tag is presented,
    version will be extracted from the latest tag and
    build metadata will be extracted for non-master branch
- Otherwise version will be set to the initial value and
    build metadata will be extracted for non-master branch
By default, build metadata is initialized with a short hash of the current Git commit.



### How To Use

Add plugin to your project:

```bash
BUILD_DEPS = version.mk
DEP_PLUGINS = version.mk
dep_version.mk = git git://github.com/manifest/version.mk.git master

include erlang.mk
```

To show version, execute the command:

```bash
$ make version
0.1.0         # for the master branch
0.1.0+2a5f212 # for any other branch
```

The same value will appear in the application resource file:

```bash
$ make && cat ebin/*.app
...
{application, 'example', [
    {description, "Example application."},
    {vsn, "0.1.0"},
    {modules, ['example_app','example_sup']},
    {registered, [example_sup]},
    {applications, [kernel,stdlib]},
    {mod, {example_app, []}},
    {env, []}
]}
```



#### Customization

To hide build metadata, set `PROJECT_VERSION_BUILD_DEFAULT` variable
to `none` (`git` is used by default).

```bash
$ PROJECT_VERSION_BUILD_DEFAULT=none make version
1.0.0
```

It is also possible to provide a custom pre-release labels and
build metadata by defining `PROJECT_VERSION_PRERELEASE` and
`PROJECT_VERSION_BUILD` variables.

```bash
$ PROJECT_VERSION_BUILD=5 make version
1.0.0+5

$ PROJECT_VERSION_PRERELEASE=pre.1 make version
1.0.0-pre.1+36916cb

$ PROJECT_VERSION_PRERELEASE=pre.1 PROJECT_VERSION_BUILD=5 make version
1.0.0-pre.1+5

$ PROJECT_VERSION_PRERELEASE=pre.1 PROJECT_VERSION_BUILD_DEFAULT=none make version
1.0.0-pre.1
```



### License

The source code is provided under the terms of [the MIT license][license].

[license]:http://www.opensource.org/licenses/MIT
[semver]:http://semver.org

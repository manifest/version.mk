# Semantic Versioning

Semantic versioning plugin for Erlang.mk.



### Overview

When added to a project, it automatically defines `PROJECT_VERSION` variable
with a value in [SemVer][semver] format extraced from Git. The version extraction will be
performed according the following rules and order priority:
- if the current Git branch matches the pattern: `release/vx.y.z`
- if the latest Git tag matches the pattern: `vx.y.z`
- otherwise the version will be equal to 0.1.0



### How To Use

Add plugin to your project:

```bash
BUILD_DEPS = version.mk
DEP_PLUGINS = version.mk
dep_version.mk = git git://github.com/manifest/version.mk.git master

include erlang.mk
```

Check a version by executing the command:

```bash
$ make version
0.1.0-2a5f212
```

Or `vsn` value of your application resource file:

```bash
$ make && cat ebin/*.app
...
{application, 'example', [
	{description, "Example application."},
	{vsn, "0.1.0-2a5f212"},
	{modules, ['example_app','example_sup']},
	{registered, [example_sup]},
	{applications, [kernel,stdlib]},
	{mod, {example_app, []}},
	{env, []}
]}
```

It's possible to provide an external build value,
making integration with CI software easier.

```bash
$ VERSION_BUILD=1 make version
0.1.0-2a5f212+1
```



### License

The source code is provided under the terms of [the MIT license][license].

[license]:http://www.opensource.org/licenses/MIT
[semver]:http://semver.org

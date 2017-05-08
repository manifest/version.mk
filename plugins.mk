## ----------------------------------------------------------------------------
## The MIT License
##
## Copyright (c) 2017 Andrei Nesterov <ae.nesterov@gmail.com>
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to
## deal in the Software without restriction, including without limitation the
## rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
## sell copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
## FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
## IN THE SOFTWARE.
## ----------------------------------------------------------------------------

PROJECT_VERSION = $(call version)

define git_tag
$(shell git show-ref --tags 1>/dev/null && git describe --tags | perl -nle 'if (m{v([0-9\.]+)}) { print $$1 } else { exit 1 }')
endef

define git_short_hash
$(shell git log -1 --format=%h)
endef

define git_short_hash_label
-$(git_short_hash)
endef

define git_branch
$(shell git rev-parse --abbrev-ref HEAD)
endef

define git_release_branch_version
$(shell echo $(call git_branch) | perl -nle 'if (m{release/v([0-9\.]+)}) { print $$1 } else { exit 1 }')
endef

define git_prefixed_branch_name
$(shell echo $(call git_branch) | perl -nle 'if (m{\w+/(.*)}) { print $$1 } else { exit 1 }')
endef

define version_build_label
$(if $(VERSION_BUILD),+$(VERSION_BUILD),)
endef

define version_initial
0.1.0
endef

define version_release_branch
$(if $(call git_release_branch_version),$(call git_release_branch_version),$(if $(call git_tag),$(call git_tag),$(call version_initial)))$(git_short_hash_label)$(version_build_label)
endef

define version_other_branch
$(if $(call git_tag),$(call git_tag),$(call version_initial))$(git_short_hash_label)$(version_build_label)
endef

## Returns a version string in SemVer format: 'x.y.z-hash+build'.
## http://semver.org
##
## Extracts version from sources in the following order of priority:
## - branch: 'release/vx.y.z'
## - tag: 'vx.y.z'
## - version_initial
define version
$(if $(findstring release/,$(call git_branch)),$(call version_release_branch),$(call version_other_branch))
endef

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
PROJECT_VERSION_INITIAL ?= 0.1.0
PROJECT_VERSION_BUILD_DEFAULT ?= git

define version_regex
(?:v?)([0-9]+\.[0-9]+\.[0-9]+(?:-(?:[0-9\w]+\.?)+)?)
endef

define git_tag
$(shell git show-ref --tags 1>/dev/null && git describe --tags | perl -nle 'if (m{$(call version_regex)}) { print $$1 } else { exit 1 }')
endef

define git_short_hash
$(shell git log -1 --format=%h)
endef

define git_branch
$(shell git rev-parse --abbrev-ref HEAD)
endef

define git_release_branch_version
$(shell echo $(call git_branch) | perl -nle 'if (m{release\/$(call version_regex)}) { print $$1 } else { exit 1 }')
endef

define version_prerelease_label
$(if $(PROJECT_VERSION_PRERELEASE),-$(PROJECT_VERSION_PRERELEASE),)
endef

define version_build_label
$(if $(PROJECT_VERSION_BUILD),+$(PROJECT_VERSION_BUILD),$(if $(findstring git,$(PROJECT_VERSION_BUILD_DEFAULT)),+$(call git_short_hash),$()))
endef

define version_initial_label
$(PROJECT_VERSION_INITIAL)
endef

define version_release_branch
$(if $(call git_release_branch_version),$(call git_release_branch_version),$(if $(call git_tag),$(call git_tag),$(call version_initial_label)))$(version_prerelease_label)$(version_build_label)
endef

define version_other_branch
$(if $(call git_tag),$(call git_tag),$(call version_initial_label))$(version_prerelease_label)$(version_build_label)
endef

define version
$(if $(findstring release/,$(call git_branch)),$(call version_release_branch),$(call version_other_branch))
endef

.PHONY: version
version:
	$(verbose) echo $(call version)

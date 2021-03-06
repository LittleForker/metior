# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2011, Sebastian Staudt

require 'metior/vcs'

module Metior

  # The Metior implementation for Git
  #
  # @author Sebastian Staudt
  module Git

    # Git will be registered as +:git+
    NAME = :git

    include Metior::VCS

    # Git's default branch is _master_
    DEFAULT_BRANCH = 'master'

  end

end

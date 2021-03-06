# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2011, Sebastian Staudt

require 'metior/commit'
require 'metior/github'
require 'metior/github/actor'

module Metior

  module GitHub

    # Represents a commit in a GitHub source code repository
    #
    # @author Sebastian Staudt
    class Commit < Metior::Commit

      include Metior::GitHub

      # Creates a new GitHub commit object linked to the repository and branch
      # it belongs to and the data parsed from the corresponding JSON data
      #
      # @param [Repository] repo The GitHub repository this commit belongs to
      # @param [String] branch The branch this commits belongs to
      # @param [Hashie:Mash] commit The commit data parsed from the JSON API
      def initialize(repo, branch, commit)
        super repo, branch

        @additions      = 0
        @authored_date  = commit.authored_date
        @committer      = Actor.new repo, commit.committer
        @committed_date = commit.committed_date
        @deletions      = 0
        @id             = commit.id
        @message        = commit.message

        authors = repo.authors(branch)
        @author = authors[Actor.id_for commit.author]
        @author = Actor.new repo, commit.author if author.nil?
        @author.add_commit self
      end

    end

  end

end

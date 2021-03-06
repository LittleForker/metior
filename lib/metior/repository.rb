# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2011, Sebastian Staudt

require 'metior/actor'
require 'metior/errors'

module Metior

  # This class represents a source code repository.
  #
  # @abstract It has to be subclassed to implement a repository representation
  #           for a specific VCS.
  # @author Sebastian Staudt
  class Repository

    # @return [String] The file system path of this repository
    attr_reader :path

    # Creates a new repository instance with the given file system path
    #
    # @param [String] path The file system path of the repository
    def initialize(path)
      @authors  = {}
      @commits  = {}
      @path     = path
    end

    # Returns all authors from the given branch in a hash where the IDs of the
    # authors are the keys and the authors are the values
    #
    # This will call +commits(branch)+ if the authors for the branch are not
    # known yet.
    #
    # @param [String] branch The branch from which the authors should be retrieved
    # @return [Hash<String, Actor>] All authors from the given branch
    # @see #commits
    def authors(branch = self.class::DEFAULT_BRANCH)
      commits(branch) if @authors[branch].nil?
      @authors[branch]
    end
    alias_method :contributors, :authors

    # Loads all commits including their authors from the given branch
    #
    # @abstract It has to be implemented by VCS specific subclasses
    # @param [String] branch The branch to load commits from
    # @return [Array<Commit>] All commits from the given branch
    def commits(branch = self.class::DEFAULT_BRANCH)
    end

    # Returns a list of authors with the biggest impact on the repository, i.e.
    # changing the most code
    #
    # @param [String] branch The branch to load authors from
    # @param [Fixnum] count The number of authors to return
    # @raise [UnsupportedError] if the VCS does not support +:line_stats+
    # @return [Array<Actor>] An array of the given number of the most
    #         significant authors in the given branch
    def significant_authors(branch = self.class::DEFAULT_BRANCH, count = 3)
      raise UnsupportedError unless supports? :line_stats

      authors = authors(branch).values.sort_by { |author| author.modifications }
      count = [count, authors.size].min
      authors[-count..-1].reverse
    end
    alias_method :significant_contributors, :significant_authors

    # Returns a list of commits with the biggest impact on the repository, i.e.
    # changing the most code
    #
    # @param [String] branch The branch to load commits from
    # @param [Fixnum] count The number of commits to return
    # @raise [UnsupportedError] if the VCS does not support +:line_stats+
    # @return [Array<Actor>] An array of the given number of the most
    #         significant commits in the given branch
    def significant_commits(branch = self.class::DEFAULT_BRANCH, count = 10)
      raise UnsupportedError unless supports? :line_stats

      commits = commits(branch).sort_by { |commit| commit.modifications }
      count = [count, commits.size].min
      commits[-count..-1].reverse
    end

    # Returns a list of top contributors in the given branch
    #
    # This will first have to load all authors (and i.e. commits) from the
    # given branch.
    #
    # @param [String] branch The branch from which the top contributors should be
    #        retrieved
    # @param [Fixnum] count The number of contributors to return
    # @return [Array<Actor>] An array of the given number of top contributors
    #         in the given branch
    # @see #authors
    def top_authors(branch = self.class::DEFAULT_BRANCH, count = 3)
      authors = authors(branch).values.sort_by { |author| author.commits.size }
      count = [count, authors.size].min
      authors[-count..-1].reverse
    end
    alias_method :top_contributors, :top_authors

  end

end

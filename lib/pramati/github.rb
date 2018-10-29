require 'httparty'
require 'octokit'

module Pramati
  class Github
    include HTTParty
    attr_accessor :client, :latest_pull_request, :respository
    base_uri 'https://gmohan.atlassian.net'
    debug_output $stdout # <= will spit out all request details to the console
    def initialize(user, password, respository)
      self.client =  Octokit::Client.new(login: user, password: password)
      self.respository = respository
      self.latest_pull_request = self.pulls[0] rescue OpenStruct.new
    end

    def pulls 
      self.client.pulls(self.respository)
    end

    def top_contributors
      self.client.contributors(self.respository)[0..7]
    end

    def latest_releases
      self.client.releases(self.respository)[0..7] rescue []
    end
  end
end
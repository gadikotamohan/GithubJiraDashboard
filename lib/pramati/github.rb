require 'httparty'
require 'octokit'

module Pramati
  class Github
    attr_accessor :client, :latest_pull_request, :respository
    def initialize(user, password, respository)
      self.client =  Octokit::Client.new(login: user, password: password)
      self.respository = respository
      self.latest_pull_request = self.pulls[0] rescue OpenStruct.new
    end

    def pulls 
      self.client.pulls(self.respository)
    end

    def top_contributors
      self.client.contributors(self.respository)[0..4]
    end

    def latest_releases
      self.client.releases(self.respository)[0..2] rescue []
    end
  end
end
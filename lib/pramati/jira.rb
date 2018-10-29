require 'httparty'
module Pramati
  class Jira
    include HTTParty
    attr_accessor :user, :password, :current_sprint, :boardId
    base_uri 'https://gmohan.atlassian.net'
    debug_output $stdout # <= will spit out all request details to the console
    def initialize(user, password, boardId)
      self.user = user
      self.password = password
      self.boardId = boardId
      self.current_sprint = get_active_sprint
    end

    def get_active_sprint 
      this = self
      response = this.class.get('/rest/agile/1.0/board/2/sprint', query: { state: 'active'} , basic_auth: { username: this.user, password: this.password }, headers: {'Accept' =>  'application/json' } )
      JSON.parse(response.to_s, object_class: OpenStruct).values[0]
    end

    def issues
      this = self
      response = this.class.get("/rest/agile/1.0/sprint/#{current_sprint.id}/issue", query: { maxResults: 200 }, basic_auth: { username: this.user, password: this.password }, headers: {'Accept' =>  'application/json' })
      JSON.parse(response.to_s, object_class: OpenStruct).issues
    end
  end
end
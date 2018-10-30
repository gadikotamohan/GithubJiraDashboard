require 'httparty'
module Pramati
  class Jira
    include HTTParty
    attr_accessor :user, :password, :current_sprints, :board_id
    base_uri 'http://jira'
    # debug_output $stdout
    def initialize(user, password, board_id)
      self.user = user
      self.password = password
      self.board_id = board_id
      self.current_sprints = get_active_sprints
    end

    def get_active_sprints 
      this = self
      response = this.class.get("/rest/agile/1.0/board/#{self.board_id}/sprint", query: { state: 'active'} , basic_auth: { username: this.user, password: this.password }, headers: {'Accept' =>  'application/json' } )
      JSON.parse(response.to_s, object_class: OpenStruct).values
    end

    def issues
      this = self
      this.current_sprints.inject({}){ |r, v|
        r[v.id] ||= []
        r[v.id].flatten!
        response = this.class.get("/rest/agile/1.0/sprint/#{v.id}/issue", query: { maxResults: 200 }, basic_auth: { username: this.user, password: this.password }, headers: {'Accept' =>  'application/json' })
        r[v.id] << JSON.parse(response.to_s, object_class: OpenStruct).issues
        r
      }
    end
  end
end
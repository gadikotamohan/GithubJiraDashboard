require 'pry'

user = ENV["JIRA_USER"]
password = ENV["JIRA_PASSWORD"]

def items_arr(issues)
  issues.inject({}) do |result, value|
    result[value.fields.status.name] ||= 0
    result[value.fields.status.name] += (value.fields.customfield_10800 || 0)
    result
  end.inject([]) do |r, v|
    r << { label: v[0], value: "#{v[1]} points" }
    r
  end
end

jira_proc = Proc.new do |board_id|
  jira = Pramati::Jira.new(user, password, board_id)
  issues = jira.issues
  jira.current_sprints.map do |sprint|
    sprint_id = sprint.id
    sprint_issues = issues[sprint_id].flatten
    items = items_arr(sprint_issues)
    send_event sprint_id, { items: items, title: "#{sprint.name} - (#{items.map{|s| s[:value].to_i}.sum }) Points" }
  end
end

SCHEDULER.every '10s' do
  jira_proc.call(189)
  jira_proc.call(127)
  jira_proc.call(135)
end
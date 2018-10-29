require 'pry'

JIRA_AUTH = {
  user: '',
  password: ''
}


jira_proc = Proc.new do |boardId|
  jira = Pramati::Jira.new(JIRA_AUTH[:user], JIRA_AUTH[:password], boardId)
  issues = jira.issues
  items = issues.inject({}) do |result, value|
    result[value.fields.status.name] ||= 0
    result[value.fields.status.name] += value.fields.customfield_10016
    result
  end.inject([]) do |r, v|
    r << { label: v[0], value: "#{v[1]} points" }
    r
  end
  { items: items, title: "#{jira.current_sprint.name} - (#{items.map{|s| s[:value].to_i}.sum }) Points" }
end

SCHEDULER.every '20m' do
  send_event 'jira_insights', jira_proc.call(2)
  send_event 'jira_internal', jira_proc.call(2)
  send_event 'jira_analyst', jira_proc.call(2)
end
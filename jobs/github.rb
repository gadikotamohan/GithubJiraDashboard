require 'pry'

AUTH = {
  user: '',
  password: ''
}


github_proc = Proc.new do |repo|
  github = Pramati::Github.new(AUTH[:user], AUTH[:password], repo)
  contributors = github.top_contributors
  items = contributors.inject([]) do |r, v|
    r << { label: v.login, value: "#{v.contributions} contributions" }
    r
  end
  { items: items, title: "Latest PR: #{github.latest_pull_request.title}" }
end


github_releases_proc = Proc.new do |repo|
  github = Pramati::Github.new(AUTH[:user], AUTH[:password], repo)
  contributors = github.latest_releases
  items = contributors.inject([]) do |r, v|
    r << { label: v.target_commitish, value: "#{v.name} - #{v.tag_name}" }
    r
  end
  { items: items }
end

SCHEDULER.every '10s' do
  send_event 'github_insights', github_proc.call("rails/rails")
  send_event 'github_internal', github_proc.call("rails/rails")
  send_event 'github_analyst', github_proc.call("rails/rails")

  send_event 'releases_insights', github_releases_proc.call("hashicorp/terraform")
  send_event 'releases_internal', github_releases_proc.call("hashicorp/terraform")
  send_event 'releases_analyst', github_releases_proc.call("hashicorp/terraform")
end
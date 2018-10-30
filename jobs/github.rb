require 'pry'
# TODO cache connections

user = ENV["GITHUB_USER"]
password = ENV["GITHUB_PASSWORD"]

github_proc = Proc.new do |repo|
  github = Pramati::Github.new(user, password, repo)
  contributors = github.top_contributors
  items = contributors.inject([]) do |r, v|
    r << { label: v.login, value: "#{v.contributions} contributions" }
    r
  end
  { items: items, title: "Latest PR(#{repo}): #{github.latest_pull_request.try(:title) || "NA"}" }
end


github_releases_proc = Proc.new do |repo|
  github = Pramati::Github.new(user, password, repo)
  contributors = github.latest_releases
  items = contributors.inject([]) do |r, v|
    p "***"
    p v.tag_name
    p "***"
    date = DateTime.strptime(v.tag_name.split("_").last, "%m%d%Y") rescue nil
    str = date.try(:strftime, "%d-%m-%Y") rescue "NA"
    r << { label: v.target_commitish, value: (str||"NA") }
    r
  end
  { items: items, title: "Releases Info: #{repo}" }
end

SCHEDULER.every '10s' do
  Pramati::CONFIG.each do |value|
    v = value[1]
    github = v[:github]
    github[:repos].each do |repo|
      send_event "#{repo}_github", github_proc.call(repo)
    end
    github = v[:deployment]
    github[:repos].each do |repo|
      send_event "#{repo}_releases", github_releases_proc.call(repo)
    end
  end

  # send_event 'github_insights', github_proc.call("rails/rails")
  # send_event 'github_internal', github_proc.call("rails/rails")
  # send_event 'github_analyst', github_proc.call("rails/rails")

  # send_event 'releases_insights', github_releases_proc.call("hashicorp/terraform")
  # send_event 'releases_internal', github_releases_proc.call("hashicorp/terraform")
  # send_event 'releases_analyst', github_releases_proc.call("hashicorp/terraform")
end
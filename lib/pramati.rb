require_relative 'pramati/jira'

module Pramati
  CONFIG = {
    insights: {
      jira: { position: { col: 1, row: 1, sizex: 2, sizey: 2 }, board_id: 189 },
      github: { position: { col: 1, row: 1, sizex: 3, sizey: 2 }, repos: ["rpx/client_portal3"] },
      deployment: { position: { col: 1, row: 1, sizex: 3, sizey: 2 }, repos: ["rpx/client_portal3"] }
    },
    internal: {
      jira: { position: { col: 1, row: 1, sizex: 1, sizey: 2}, board_id: 127 },
      github: { position: { col: 1, row: 1, sizex: 2, sizey: 1 }, repos: ["rpx/docblaster", "rpx/jruby-ppt-generator", "rpx/member_credit", "rpx/acquiflow", "rpx/isys", "rpx/report_builder", "rpx/internal_apps_header", "rpx/internal_authentication_service"] },
      deployment: { position: { col: 1, row: 1, sizex: 2, sizey: 1 }, repos: ["rpx/docblaster", "rpx/jruby-ppt-generator", "rpx/member_credit", "rpx/acquiflow", "rpx/isys", "rpx/report_builder", "rpx/internal_apps_header", "rpx/internal_authentication_service"] }
    }
  }.freeze
end
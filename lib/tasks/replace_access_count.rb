require_relative "job_base"
require 'google/apis/analyticsreporting_v4'

module Tasks
  class ReplaceAccessCount < JobBase
    def run
      Article.transaction do
        Article.update_all(access_count: 0)

        load_counts.each do |a_id, count|
          a = Article.find_by(id: a_id)
          next unless a
          a.access_count = count
          a.save!
        end
      end
    end

    private

    def load_counts
      counts = {}

      analytics_data.each do |metrics|
        uri = metrics[:dimensions][0]
        count = metrics[:metrics][0][:values][0]
        next unless uri =~ %r!\A/articles/(\d+)\z!
        counts[$1.to_i] = count.to_i
      end

      counts
    end

    def analytics_data
      view_id = "6950089"
      scope = ['https://www.googleapis.com/auth/analytics.readonly']
      analytics = Google::Apis::AnalyticsreportingV4
      json_key_io = File.open("/srv/kaeruspoon/google-auth-cred.json")

      client = analytics::AnalyticsReportingService.new
      client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: json_key_io, scope: scope
      )

      end_date = Date.today.to_s
      start_date = 60.days.ago.to_date.to_s
      date_range = analytics::DateRange.new(start_date: start_date, end_date: end_date)
      metric = analytics::Metric.new(expression: 'ga:pageviews', alias: 'pv')
      dimension = analytics::Dimension.new(name: 'ga:pagePath')
      request = analytics::GetReportsRequest.new(
        report_requests: [analytics::ReportRequest.new(
          view_id: view_id, metrics: [metric], dimensions: [dimension], date_ranges: [date_range]
        )]
      )
      client.batch_get_reports(request).to_h[:reports][0][:data][:rows]
    end
  end
end

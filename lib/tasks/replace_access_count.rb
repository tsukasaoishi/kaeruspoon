require_relative "job_base"

module Tasks
  class ReplaceAccessCount < JobBase
    def initialize(*args)
      @file = args.first
    end

    def run
      Article.transaction do
        Article.update_all(access_count: 0)

        load_counts.each do |a_id, count|
          a = Article.find_by(id: a_id)
          next unless a
          puts "#{a.id}\t#{count}"
          a.access_count = count
          a.save!
        end
      end
    end

    private

    def load_counts
      counts = {}

      File.open(@file, "r") do |f|
        f.each do |line|
          uri, count = line.split("\t")[0..1]
          next unless uri =~ %r!\A/articles/(\d+)\z!
          counts[$1.to_i] = count.to_i
        end
      end

      counts
    end
  end
end

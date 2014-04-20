module Tasks
  class JobBase
    def self.run(*args)
      new(*args).run
    end

    def initialize(*args)
    end

    def run
    end

    private

    def checked_time
      @checked_time ||= get_checked_time
    end

    def get_checked_time
      return default_checked_time unless File.exist?(checked_time_file)
      Time.parse(File.read(checked_time_file)) rescue default_checked_time
    end

    def default_checked_time
      Time.now.beginning_of_day
    end

    def set_checked_time
      return unless @latest_time
      File.open(checked_time_file, "w") do |f|
        f.write(@latest_time.to_s(:db))
      end
    end

    def checked_time_file
      raise "must define checked_time_file_path"
    end
  end
end

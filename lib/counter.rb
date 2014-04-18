module Counter
  def count_up
    now = Time.now.to_i
    count, time = read_counter
    count += 1

    if access_count > 0 && (now - time) < interval
      write_counter(count, time)
    else
      update_count(count)
      write_counter(0, now)
    end
  end

  private

  def read_counter
    if data = Rails.cache.read(counter_key)
      data.split(":").map{|i| i.to_i}
    else
      [0, Time.now.to_i]
    end
  end

  def write_counter(count, time)
    Rails.cache.write(counter_key, "#{count}:#{time}", expires_in: 4.weeks)
  end

  def delete_counter
    Rails.cache.delete(counter_key)
  end

  def update_count(count)
    self.access_count += count
    save
  end

  def counter_key
    raise "you must define counter_key method"
  end

  def interval
    600
  end
end

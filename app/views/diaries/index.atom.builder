atom_feed(language: :ja) do |feed|
  feed.title "kaeruspoon"
  feed.updated Time.local(@calendar.first.year, @calendar.first.month, 1)

  @calendar.each do |c|
    feed.entry(
      c,
      url: date_diaries_path(year: c.year, month: c.month),
      id: %Q|tag:#{request.host},:#{date_diaries_path(year: c.year, month: c.month)}|
    ) do |entry|
      entry.title("#{c.year}年#{c.month}の日記")
      entry.author do |author|
        author.name "Tsukasa OISHI"
      end
    end
  end
end

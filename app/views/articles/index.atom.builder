atom_feed(:language => :ja) do |feed|                                                                 
  feed.title "kaeruspoon"                                                                             
  feed.updated @articles.first.created_at                                                             

  @articles.each do |a|                                                                               
    feed.entry(a) do |entry|                                                                          
      entry.title(a.title)                                                                            
      entry.content(TextDecorator.replace(a.body), :type=>'html')                                                   
      entry.author do |author|                                                                        
        author.name "Tsukasa OISHI"
      end                                                                                             
    end                                                                                               
  end                                                                                                 
end          

class List
  
  def list_lang(lang)
    Console.log "list #{lang}"
    Models.each_for_lang(lang) do |id,fn|
      puts " [#{id}] #{fn}"
    end
  end

  def list_all
    Console.log "list all"
    puts "#{Models.langs.count} languages"
    Models.langs.each do |lang|
      puts "#{lang} models: #{Models.count_for_lang(lang)}"
    end
  end

  def exec(*params)
    if params.count==0
      list_all
    elsif params.count==1 and Models.has_lang?(params[0])
      list_lang params[0]
    else
      Console.error "list | list <a-language>"
    end
  end
end
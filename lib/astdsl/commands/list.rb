class List

  def list_lang(lang)
    Console.log "list #{lang}"
    Models.each_for_lang(lang) do |id,fn,m|
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

  def list_class(class_name)
    clazz = get_class(class_name)
    list = {}
    Models.langs.each do |lang|
      Models.each_for_lang(lang) do |id,fn,m|
        res = RGen::query type:clazz
        list[id,fn] = res if res.count>0
      end
    end
    puts "list #{clazz}"
    list.each do |k,v|
      id,fn = k
      puts "found in [id] #{fn}"
    end
  end

  def exec(*params)
    if params.count==0
      list_all
    elsif params.count==1 and Models.has_lang?(params[0])
      list_lang params[0]
    elsif params.count==1 and get_class(params[0])
      list_class params[0]
    else
      Console.error "list | list <a-language>"
    end
  end

  private

  def get_class(class_name)
    begin
      res = eval class_name
      return nil unless res.is_a? Class
      res
    rescue
      nil
    end
  end
end
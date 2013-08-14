class Load

  def hidden?(p)
    p=='.git'
  end

  def load(p)
    if File.directory? p
      Console.log "in dir #{p}"
      load_dir(p)
    else
      load_file(p)
    end
  end

  def load_dir(p)
    #Console.log "In dir #{p}"
    Dir.new(p).each do |c|
      if c!='.' and c!='..' and not hidden?(c)
        load("#{p}/#{c}")
      end
    end
  end

  def load_ruby_file(p)
    Console.log "loading ruby file #{p}"
    begin
      model = RubyMM.parse_file(p)
      Models.store_model('ruby',p,model)
    rescue Exception => e
      puts "Error loading #{p}: #{e}"
      puts "Details:"
      e.backtrace.each do |el|
        puts "  #{el}"
      end
    end
  end

  def load_file(p)
    if p.end_with? '.rb'
      load_ruby_file(p)
    else
    end
  end

	def exec(*params)
		params.each do |p|
      if File.exists? p
        load(p)
      else
        puts "skipping #{p} because it does not exist"
      end
		end
	end

end
$: << './lib'

require 'rubymm'
require 'astdsl/str_utils'
require 'astdsl/commands/print'

class Models
  @next_id = 1
  @models = Hash.new { |h,k| h[k] = {} }

  def self.store_model(lang,filename,model)
    @models[lang][filename] = @next_id,model
    @next_id+=1
  end

  def self.langs
    @models.keys
  end

  def self.has_lang?(lang)
    @models.has_key? lang
  end

  def self.count_for_lang(lang)
    @models[lang].count
  end

  def self.each_for_lang(lang,&block)
    @models[lang].each do |fn,arr|
      id,model = arr
      block.call(id,fn)
    end
  end

  def self.has_id?(searched_id)
    nil!=internal_by_id(searched_id)
  end

  def self.model_by_id(searched_id)
    res = internal_by_id searched_id
    return nil unless res
    res[2]
  end

  def self.lang_by_id(searched_id)
    res = internal_by_id searched_id
    return nil unless res
    res[0]
  end

  def self.filename_by_id(searched_id)
    res = internal_by_id searched_id
    return nil unless res
    res[1]
  end

  private

  def self.internal_by_id(searched_id)
    @models.each do |lang,models|
      models.each do |fn,arr|
        id,model = arr
        return lang,fn,model if (id==searched_id)
      end
    end
    return nil
  end

end

class Console
	def prompt
		'[]'
	end
  def self.verbose
    true
  end
  def self.log(text)
    puts(text) if verbose
  end
  def self.error(text)
    puts "Error: #{text}"
  end
end

class List
  
  def list_lang(lang)
    Console.log "list #{lang}"
    Models.each_for_lang(lang) do |id,fn|
      puts " [#{id}] #{fn}"
    end
  end

  def exec(*params)
    if params.count==0
      Console.log "list all"
      puts "#{Models.langs.count} languages"
      Models.langs.each do |lang|
        puts "#{lang} models: #{Models.count_for_lang(lang)}"
      end
    elsif params.count==1 and Models.has_lang?(params[0])
      list_lang params[0]
    else
      Console.error "list | list <a-language>"
    end
  end
end


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

$console = Console.new

loop do
  ('%s> ' % $console.prompt).display
  input = gets.chomp
  command, *params = split_string(input)
  case command
  	when /\Aload\z/i
  		Load.new.exec *params
    when /\Aprint\z/i
      Print.new.exec *params
    when /\Alist\z/i
      List.new.exec *params
    when /\Als\z/i
      List.new.exec *params
    when /\Ahelp\z/i
      puts 'Help message'
    when /\Aexit\z/i
      abort('exit...')
    else
      puts "Invalid command: '#{command}'"
  end
end
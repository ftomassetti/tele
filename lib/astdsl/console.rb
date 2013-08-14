$: << './lib'

require 'rubymm'
require 'astdsl/str_utils'
require 'astdsl/commands/list'
require 'astdsl/commands/load'
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
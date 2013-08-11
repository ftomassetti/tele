class Console
	def prompt
		'[]'
	end
end

class Load

	def exec(*params)
		puts "Loading #{params.count}"
	end

end

$console = Console.new

loop do
  ('%s> ' % $console.prompt).display
  input = gets.chomp
  command, *params = input.split /\s/
  case command
  	when /\Aload\z/i
  		puts "= Load"
    when /\Ahelp\z/i
      puts App.help_text
    when /\Aopen\z/i
      Task.open params.first
    when /\Ado\z/i
      Action.perform *params
    else
      puts 'Invalid command'
  end
end
def split_string(str)
	i = 0
	single_apix = false
	double_apix = false
	current_word = ''
	words = []
	str.split("").each do |c|
  		#puts "#{i}) #{c}"
		if c=='\''
			if single_apix
				# close the string
				words = words << current_word
				current_word = ''
				single_apix = false
			elsif double_apix
				# add the char
				current_word = current_word + '\''
			else
				single_apix = true
				words = words << current_word if current_word.length > 0
				current_word = ''
			end
		elsif  c=='"'
			if double_apix
				# close the string
				words = words << current_word
				current_word = ''
				double_apix = false
			elsif single_apix
				# add the char
				current_word = current_word + '\''
			else
				double_apix = true
				words = words << current_word if current_word.length > 0
				current_word = ''
			end
		elsif c==' ' and not single_apix and not double_apix
			words = words << current_word if current_word.length > 0
			current_word = ''
		else
			current_word = current_word + c
		end
			
  		i += 1
	end
	
	words = words << current_word if current_word.length > 0
	words
end
require 'helper'

require 'test/unit'
require 'astdsl/str_utils'
 
class TestOperations < Test::Unit::TestCase

	def test_split_string_empty
		res = split_string('')

		assert_equal 0,res.count
	end

	def test_split_string_one_word
		res = split_string('ciao')

		assert_equal 1,res.count
		assert_equal 'ciao',res[0]
	end

	def test_split_string_two_words
		res = split_string('ciao come')

		assert_equal 2,res.count
		assert_equal 'ciao',res[0]
		assert_equal 'come',res[1]
	end

	def test_split_string_one_str
		res = split_string('"ciao come"')

		assert_equal 1,res.count
		assert_equal 'ciao come',res[0]
	end

	def test_split_string_mix
		res = split_string('hi "come stai" is good?')

		assert_equal 4,res.count
		assert_equal 'hi',res[0]
		assert_equal 'come stai',res[1]
		assert_equal 'is',res[2]
		assert_equal 'good?',res[3]
	end

end
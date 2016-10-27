require 'minitest/autorun'
require 'minitest/pride'
require './lib/dictionary'

class DictionaryTest < Minitest::Test
  def test_word_in_dictionary
    dictionary = Dictionary.new

    word = "cat"
    assert_equal "#{word.upcase} is a known word", dictionary.word_is_in_dictionary(word)
  end

  def test_not_everything_is_in_dictionary
    dictionary = Dictionary.new

    word = "clearlynotaword"
    assert_equal "#{word.upcase} is not a known word", dictionary.word_is_in_dictionary(word)
  end
end

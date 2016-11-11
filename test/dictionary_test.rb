require './test/test_helper'

class DictionaryTest < Minitest::Test
  attr_reader :d
  def setup
    @d = Dictionary.new
  end
  def test_word_in_dictionary
    word = "cat"
    expected = "#{word.upcase} is a known word"
    assert_equal expected, d.word_is_in_dictionary(word)
  end

  def test_not_everything_is_in_dictionary
    word = "clearlynotaword"
    expected = "#{word.upcase} is not a known word"
    assert_equal expected, d.word_is_in_dictionary(word)
  end
end

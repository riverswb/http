class Dictionary

  def word_is_in_dictionary(word)
    dictionary = File.read("/usr/share/dict/words")
    if dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end
end

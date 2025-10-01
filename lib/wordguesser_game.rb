class WordGuesserGame
  # creates getter and setter methods automatically
  attr_accessor :word, :guesses, :wrong_guesses

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  def initialize(word)
    raise ArgumentError, "word must be non-empty" if word.nil? || word.strip.empty?
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.strip.empty?
    ch = letter.downcase
    raise ArgumentError unless ch.match?(/\A[a-z]\z/)
  
    # duplicate -> false (ignored)
    return false if @guesses.include?(ch) || @wrong_guesses.include?(ch)
  
    if @word.include?(ch)
      @guesses << ch
    else
      @wrong_guesses << ch
    end
      true
  end
  

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c) ? c : '-' }.join
  end

  def check_win_or_lose
    return :win  if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end
end

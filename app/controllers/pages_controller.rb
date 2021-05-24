require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def new
    @letters = Array.new(10) {('A'..'Z').to_a.sample}
  end

  def score
    @userword = params[:word].upcase
    @letters = params[:letters].split
    @included = included?(@userword, @letters)
    @english_word = english_word?(@userword)
    @compute_score = compute_score(@userword)
  end

  private
# The word can’t be built out of the original letters
  def included?(userword, letters)
    userword.chars.all? { |letter| userword.count(letter) <= letters.count(letter) }
  end

# The word is valid according to the grid and is an English word
    def english_word?(word)
      response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
      json = JSON.parse(response.read)
      return json['found']
    end

  def compute_score(userword)
    if included?(userword)
      score = userword.size * 2
    else
      score = 0
    end
  end

  # def score_and_message(userword, letters, time)
  #   if included?(@userword.upcase, @letters)
  #     if english_word?(@userword)
  #       score = compute_score(@userword)
  #       [score, "well done"]
  #     else
  #       [0, "not an english word"]
  #     end
  #   else
  #     [0, "not in the letters given"]
  #   end
  # end

  # def run_game(userword, letters, start_time, end_time)
  #   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
  #   result = { time: end_time - start_time }

  #   score_and_message = score_and_message(userword, letters, result[:time])
  #   result[:score] = score_and_message.first
  #   result[:message] = score_and_message.last
  #   return result
  # end
end
# The word is valid according to the letters, but is not a valid English word


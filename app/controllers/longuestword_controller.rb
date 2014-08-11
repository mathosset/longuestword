require 'json'
require 'open-uri'

class LonguestwordController < ApplicationController
  def game
    @grid = generate_grid
    @start_time = Time.now.to_f
    @query = params[:query]
    flash[:grid] = @grid
    flash[:start_time] = @start_time
  end

  def generate_grid
    #TODO: generate random grid of letters
    letters = []
    for i in (1..15) do
      letters << ("A".."Z").to_a.sample
    end
    return letters = letters.join(" ")
  end


  def score
    @end_time = Time.now.to_f
    @time_duration_all = @end_time - flash[:start_time]
    # @time_duration = sprintf("%.2f", @time_duration_all)
    @time_duration = "%.2f" % @time_duration_all
    @result = run_game
  end

  def run_game
    #TODO: runs the game and return detailed hash of result
    @query = params[:query]
    json_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{@query}"
    hash = {}
    open (json_url) do |stream|
      hash = JSON.parse(stream.read)
    end

    array = []
    @query.upcase.split("").each do |letter|
      if flash[:grid].include? letter
        array << true
      else
        array << false
      end
    end

    if array.include?(false)

      result = {
          time: @time_duration,
          translation: nil,
          score: 0,
          message: "not in the grid"
        }

    elsif hash["Error"] != nil

      result = {
        time: @time_duration,
        translation: nil,
        score: 0,
        message: "not an english word"
      }

    elsif
      result = {
        time: @time_duration,
        translation: hash["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"],
        score: 1,
        message: "well done"
      }
    end

    return result
  end



end

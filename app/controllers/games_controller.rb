require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample(1)
    end
    @letters
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    html_doc = JSON.parse(URI.open(url).read)
    @letters = JSON.parse(params[:letters])
    session[:result] = 0 if session[:result].nil?
    session[:result] += (html_doc['length']).to_i
    @session_result = session[:result]
    @score = if html_doc['found'] == false
               "Sorry but #{params[:answer].upcase} does not seem to be a valid English word"
             elsif params[:answer].split('').all? { |letter| @letters.split('').include? letter }
               "Congratulations! #{params[:answer].upcase} is a valid English word.
               Your score is #{(html_doc['length']).to_i}"
             else
               "Sorry but #{params[:answer].upcase} can not be built out of #{@letters.flatten.join(', ')}"
             end
  end
end

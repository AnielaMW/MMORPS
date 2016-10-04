require 'sinatra'
require 'pry'

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/' do
  if session[:visit_count].nil?
    session[:visit_count] = 1
    session[:user_wins] = 0
    session[:computer_wins] = 0
  else
    session[:visit_count] += 1
  end
  erb :index
end

post '/create' do
  session[:username] = params[:username]
  redirect '/'
end

post '/users_choice' do
  session[:users_choice] = params[:users_choice]
  redirect '/outcome'
end

get '/outcome' do
  @user = session[:users_choice]
  @computer = computers_choice
  # @user_has_won = user_has_won?(@user, @computer)
  if user_has_won?(@user, @computer)
    session[:user_wins] += 1
  elsif computer_has_won?(@user, @computer)
    session[:computer_wins] += 1
  end

  erb :outcome
end

get '/reset' do
  redirect '/'
end

get '/new_game' do
  session[:user_wins] = 0
  session[:computer_wins] = 0
  redirect '/'
end

def computers_choice
  ["Rock", "Paper", "Scissors"].sample
end

def user_has_won?(user, computer)
  (user == "Rock" && computer == "Scissors") ||
  (user == "Paper" && computer == "Rock") ||
  (user == "Scissors" && computer == "Paper")
end

def computer_has_won?(user, computer)
  (computer == "Rock" && user == "Scissors") ||
  (computer == "Paper" && user == "Rock") ||
  (computer == "Scissors" && user == "Paper")
end

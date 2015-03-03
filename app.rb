require 'sinatra'
require 'sinatra/activerecord'
require './twitter_search'

enable :sessions
get '/' do
	#say hello and show form
	erb :index
end

post '/submit' do
	#submit the first word and second word, redirect to the result page.
	session[:word_1]= params[:word_1]
	session[:word_2]= params[:word_2]
	redirect '/result'
	end

get '/result' do
	#post result from twitter server
	tw=TWITTER_SEARCH.new(session[:word_1],session[:word_2])
	answer=tw.run
	@word_1=session[:word_1]
	@word_2=session[:word_2]
	@sample=answer["sample"]
	@score=answer["score"]
	@index=answer["both"]
	@review=answer["review"]
	erb :result
end

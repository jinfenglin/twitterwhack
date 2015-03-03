require 'rubygems'
require 'oauth'
require 'json'
class TWITTER_SEARCH
	def initialize(w1,w2)
		@consumer_key = OAuth::Consumer.new(
			"DP9OyShUb15o31TQbI0GYuygs",
			"O9JcwKmdiDXpzB70nCYzdjft2Mc2hFPzcwI1l10q1UZ4nxgFr9")
		@access_token = OAuth::Token.new(
			"3065738913-OMMajF4woCX05enHf9Ii8SQdPQBIvegVZYI2GMG",
			"Q49JqwXx5yLOA7kcrowE6LqV8OG08gO4sdPNNU6tM088I")
		baseurl = "https://api.twitter.com"
		path    = "/1.1/search/tweets.json"
		query_both= "q=#{w1}%20#{w2}&count=100&lang=en"
		query_w1="q=#{w1}&count=100&lang=en"
		query_w2="q=#{w2}&count=100&lang=en"

		@address_both = URI("#{baseurl}#{path}?#{query_both}")
		@address_w1 = URI("#{baseurl}#{path}?#{query_w1}")
		@address_w2 = URI("#{baseurl}#{path}?#{query_w2}")
	end

	def search(address)
		@http    = Net::HTTP.new address.host,address.port
		@http.use_ssl     = true
		@http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new address.request_uri
		request.oauth! @http, @consumer_key, @access_token
		@http.start
		response = @http.request request
		if response.code == '200' then
			tweet = JSON.parse(response.body)
			return tweet
		end
	end

	def get_sample_text(tweet)
		tweet["statuses"].each do |text|
			puts text["text"]

			return text["text"]
		end
	end
	def output_text(tweet)
		puts tweet
		tweet["statuses"].each do |text|
			puts text["text"]
		end

	end

	def count(tweet)
		#return tweet["search_metadata"]["count"]
		return tweet["statuses"].length
	end
	def run()
		t_both=search(@address_both)
		t_w1=search(@address_w1)
		t_w2=search(@address_w2)

		c_both= count(t_both)
		c_w1= count(t_w1)
		c_w2= count(t_w2)
		review="try again!"
		if c_both ==0 
			review="You got whack it!"
		elsif c_both <5
			review= "exellent!"
		elsif c_both <90
			review="hmm, not bad!"
		else
			review="try again!"
		end
		output_text(t_both)
		return {"sample"=>get_sample_text(t_both),"both"=>c_both,
	  "score"=>c_w1*c_w2,"review"=>review}
	end
end	

tw=TWITTER_SEARCH.new 'google','map'
an=tw.run
puts an["both"]


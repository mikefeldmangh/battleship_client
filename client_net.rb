require 'typhoeus'

require 'rubygems'
require 'json'

def post_request (url, params)
  response = Typhoeus::Request.post(url, :body => params)
  object_response = JSON.parse(response.body)
  puts object_response
  object_response
end

def get_request (url, params)
  response = Typhoeus::Request.get(url, :params => params)
  object_response = JSON.parse(response.body)
  puts object_response
  object_response
end

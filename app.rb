# /app.rb

require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

exchange_rates_key = ENV.fetch("EXCHANGE_RATES_KEY")

# define a route
get("/") do
  # build the API url, including the API key in the query string
  api_url = "http://api.exchangerate.host/list?access_key=#{exchange_rates_key}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @currencies_hash = parsed_data.fetch("currencies")

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")

  api_url = "http://api.exchangerate.host/list?access_key=#{exchange_rates_key}"
  
  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @currencies_hash = parsed_data.fetch("currencies")

  # render a view template where I show the symbols
  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "http://api.exchangerate.host/convert?access_key=#{exchange_rates_key}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @currencies_hash = parsed_data.fetch("info")

  # render a view template where I show the symbols
  erb(:to_currency)
end

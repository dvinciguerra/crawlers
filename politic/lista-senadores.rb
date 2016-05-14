#!/usr/bin/env ruby

# imports
require 'json'
require 'open-uri'
require 'nokogiri'

# site url
site_url = 'http://www25.senado.leg.br/web/senadores/em-exercicio'

# getting site content
file = open(site_url)

# parse and iterate dom
@dom = Nokogiri::HTML(file.read)
table = @dom.at_css("table#senadoresemexercicio-tabela-senadores")

data = []
table.css('tbody > tr:not(.search-group-row)').each do |row|
  cols = row.css('td')

  m = Hash.new
  m[:name]  = cols[0].at_css('a').children.text
  m[:link]  = cols[0].at_css('a').attributes['href'].value
  m[:party] = cols[1].text
  m[:state] = cols[2].text
  m[:time]  = cols[3].text
  m[:phone] = cols[4].text
  m[:email] = cols[5].text

  data.push(m)
end

# output json data
puts JSON.generate(data)


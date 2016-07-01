#!/usr/bin/env ruby
# 2016 (c) Daniel Vinciguerra

require 'json'
require 'open-uri'
require 'nokogiri'


# abre o site do tribunal superior eleitoral
source = open 'http://www.tse.jus.br/partidos/partidos-politicos/registrados-no-tse';

# abre e interpreta o html
html = Nokogiri::HTML(source)

partidos = {}

# seleciona as linhas da tabela de partidos
html.css('table.grid tr:not(:first-child)').each do |row|
  c = row.css('td')
  if c[0] && c[1]
    partidos[c[1].text] = {:id => c[0].text, :sigla => c[1].text, :nome => c[2].text}
  end
end

# imprime a lista em formato json
puts JSON.generate({party: partidos})

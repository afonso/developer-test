require "json"
require "nokogiri"
require_relative "spider" #include of spider.rb

class Sintegra < Spider
  def parse(html)
    data = Nokogiri::HTML(html)
    content = []
    data.search('table.resultado tr td table').map do |row|
      row.search('tr td.titulo, tr td.valor').each_slice(2) do |title|
      	if title[0] and title[1]
	    	content << { title[0].text.strip.gsub(/[\s:]+$/ ,"") => title[1].text.strip }
	    end
      end
    end
    content.to_json
  end

  def parse_regex(html)
  	content = []
    filter = /<td.*?class=['\"]titulo['\"].*?>(?<TITLE>[\s\S]*?)?<\/td>\s*<td.*?class=['\"]valor['\"].*?>(?<VALUE>[\s\S]*?)?<\/td>/
    html.scan(filter).map do |row|
      content << { clean(row[0]) => clean(row[1]) }
    end
    content.to_json
  end

  def clean(str)
  	c = /<("[^"]*"|'[^']*'|[^'">])*>|([\s:\->]+$)/
  	str.gsub(c, '').strip.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''})
  end
end

require_relative "sintegra" #include of sintegra.rb

params = {
	'num_cnpj' => '31.804.115-0002-43',
	'botao' => 'Consultar'
}
spider = Sintegra.new("http://www.sintegra.es.gov.br")
request = spider.post("/resultado.php", params)

#output with nokogiri
output = spider.parse(request.body.gsub("&nbsp;",""))

#output with only regular expression
output_regex = spider.parse_regex(request.body.force_encoding("iso-8859-1").gsub("&nbsp;",""))

puts output_regex
#puts output
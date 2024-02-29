require "httparty"
require "nokogiri"
require "pry"

PokemonProduct = Struct.new(:url, :image, :name, :price) #struct is kind of like ClassLite, allows you to not have to make a full class

response = HTTParty.get("https://scrapeme.live/shop/") #sometimes you will have to pass a User-Agent header- some sites block HTTP requests according to their headers
document = Nokogiri::HTML(response.body)
html_products = document.css("li.product")

pokemon_products = []

html_products.each do |html_product|
    url = html_product.css("a").first.attribute("href").value
    image = html_product.css("img").first.attribute("src").value
    name = html_product.css("h2").first.text
    price = html_product.css("span").first.text

    pokemon_product = PokemonProduct.new(url, image, name, price)

    pokemon_products << pokemon_product
end


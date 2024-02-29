require "httparty"
require "nokogiri"
require "pry"

PokemonProduct = Struct.new(:url, :image, :name, :price)
pokemon_products = []
pages_to_scrape = ["https://scrapeme.live/shop/page/1/"]
pages_discovered = ["https://scrapeme.live/shop/page/1/"]

i = 0
limit = 48

while pages_to_scrape.length != 0 && i < limit do
    page_to_scrape = pages_to_scrape.pop
    response = HTTParty.get(page_to_scrape)
    document = Nokogiri::HTML(response.body)

    page_numbers = document.css("a.page-numbers")
    pagination_links = 
    page_numbers.map do |a|
        a.attribute("href").value
    end

    pagination_links.each do |new_pagination_link|
        if !(pages_discovered.include? new_pagination_link) && !(pages_to_scrape.include? new_pagination_link)
            pages_to_scrape << new_pagination_link
        end
        pages_discovered << new_pagination_link
    end
    pages_discovered = pages_discovered.to_set.to_a

    html_products = document.css("li.product")
    html_products.each do |html_product|
        url = html_product.css("a").first.attribute("href").value
        image = html_product.css("img").first.attribute("src").value
        name = html_product.css("h2").first.text
        price = html_product.css("span").first.text
    
        pokemon_product = PokemonProduct.new(url, image, name, price)
    
        pokemon_products << pokemon_product
    end
    i = i + 1
end

csv_headers = ["url", "image", "name", "price"]
CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv|
    pokemon_products.each do |pokemon_product|
        csv << pokemon_product
    end
end


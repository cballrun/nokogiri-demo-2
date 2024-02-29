require "httparty"
require "nokogiri"
require 'pry'

pages_to_scrape = ["https://scrapeme.live/shop/page/1/"]
pages_discovered = ["https://scrapeme.live/shop/page/1/"]
i = 0
limit = 4

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
            pages_to_scrape << new_pagination_link #creates a queue for pages to scrape
        end
        pages_discovered << new_pagination_link
    end
    pages_discovered = pages_discovered.to_set.to_a #removes duplicaties from pages discovered
    i = i + 1
end



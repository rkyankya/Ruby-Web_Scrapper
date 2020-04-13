require 'nokogiri'
require 'httparty'

puts 'Enter Keywords for Freelancer.com  Web scraping jobs'

class Scraper
  def initialize(keywords, site)
    @keywords = keywords
    @site = site
    @jobs = []
  end

  def scrape
    page = 1
    last_page = 3

    while page <= last_page
      parsed_html = parse_html(make_url(@site, page))

      case @site
      when 'freelancer'
        scrape_freelancer(parsed_html)
      end

      page += 1
    end

    @jobs
  end

  private

  def parse_keywords
    @keywords.map! { |keyword| keyword.gsub(' ', '-') }
    search_query = if @site == 'freelancer'
                     @keywords.join('%20')
                   else
                     @keywords.join('/skill/')
                   end
    search_query
  end

  def make_url(_site, page)
    search_url = "https://www.freelancer.com/jobs/#{page}/?keyword=#{parse_keywords}"
    search_url
  end
end

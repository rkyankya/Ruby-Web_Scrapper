require 'nokogiri'
require 'httparty'

puts 'Enter Keywords for Freelancer.com  Web scraping jobs press enter twice once you are finished'

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

  def parse_html(url)
    unparsed_page = HTTParty.get(url).body
    parsed_page = Nokogiri::HTML(unparsed_page)
    parsed_page
  end

  def last_page(site, parsed_page)
    case site
    when 'freelancer'
      job_listings = parsed_page.css('div.JobSearchCard-item')
      total = parsed_page.css('span#total-results').text.gsub(',', '').to_f
    end

    return 0 if job_listings.count.zero?

    per_page = job_listings.count.to_f
    last_page = (total / per_page).ceil.to_i

    last_page
  end

  def scrape_freelancer(parsed_html)
    job_listings = parsed_html.css('div.JobSearchCard-item')
    job_url = 'https://www.freelancer.com'

    job_listings.each do |job_listing|
      tags = []
      tags_text = job_listing.css('a.JobSearchCard-primary-tagsLink')
      tags_text.each do |tag|
        tags << tag.text
      end
      job = {
        title: job_listing.css('a.JobSearchCard-primary-heading-link').text.strip.gsub(/\\n/, ' '),
        rate: job_listing.css('div.JobSearchCard-secondary-price').text.delete(' ').delete("\n").delete('Avg Bid'),
        desc: job_listing.css('p.JobSearchCard-primary-description').text.strip,
        tags: tags.join(', '),
        url: job_url + job_listing.css('a.JobSearchCard-primary-heading-link')[0].attributes['href'].value
      }

      @jobs << job
    end

    @jobs
  end
end

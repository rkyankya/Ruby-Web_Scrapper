require_relative '../lib/freelancer.rb'
require_relative '../lib/file_creater.rb'

def main
  keywords = []

  loop do
    input = gets
    break if input == "\n"

    keywords << input.chomp
  end

  freelancer = Scraper.new(keywords, 'freelancer')

  sleep(2)

  puts "Scraping freelancer.com...\n\n"
  sleep(1)
  puts "Please wait...\n"
  scrape_freelancer = freelancer.scrape
  puts "\n#{scrape_freelancer.count} jobs scraped\n\n\n"

  puts 'no job found in freelancing.com' if scrape_freelancer == 'no job found'

  if scrape_freelancer == 'no job found'
    puts 'No job found with the given keywords.'
    abort
  else
    puts "Scraping complete!\n\n"
  end

  sleep(1)

  export_freelancer = CSVExporter.new(scrape_freelancer, 'freelancer')

  puts "Exporting to CSV...\n\n"

  sleep(3)

  export_freelancer.export unless scrape_freelancer == 'no job found'

  puts "Exportation complete!\n\n"

  sleep(1)
  puts "You will find a csv files in current working directory with the exported data.\n\n\n"
  sleep(1)
  puts 'Terminating...'
  sleep(2)
end

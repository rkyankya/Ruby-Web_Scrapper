require_relative 'spec_helper.rb'
require_relative '../lib/freelancer.rb'

require 'nokogiri'

RSpec.describe Scraper do
  # rubocop:disable Layout/LineLength
  let(:raw_html_freelancer) { '<span id="total-results">21</span><div class="JobSearchCard-item "><div class="JobSearchCard-item-inner" data-project-card="true"><div class="JobSearchCard-primary"><div class="JobSearchCard-primary-heading"> <a href="/projects/php/develop-website-24431323/" class="JobSearchCard-primary-heading-link" data-qtsb-section="page-job-search-new" data-qtsb-subsection="card-job" data-qtsb-label="link-project-title" data-heading-link="true"> Develop My Website </a></div><p class="JobSearchCard-primary-description"> This is an online Social Blogging forum! built on <b>PHP</b> [login to view URL]! [login to view URL]Please check the Website throughly and then Quote!You may have to complete the front end and built an admin panel as well!You may have to design and develop in ci! so knowledge in CI , web designing and Photoshop is prerequisite!</p><div class="JobSearchCard-primary-tags" data-qtsb-section="page-job-search-new" data-qtsb-subsection="card-job" data-qtsb-label="link-skill"> <a class="JobSearchCard-primary-tagsLink" href="/jobs/codeigniter/">Codeigniter</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/graphic-design/">Graphic Design</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/html/">HTML</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/php/">PHP</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/website-design/">Website Design</a></div></div><div class="JobSearchCard-secondary"><div class="JobSearchCard-secondary-price"> $117</div></div></div></div>' }

  # rubocop:enable Layout/LineLength

  let(:parsed_html_freelancer) { Nokogiri::HTML(raw_html_freelancer) }

  let(:scraper) { Scraper.new(%w[any keyword], 'any_site') }

  describe '.scrape_freelancer' do
    it 'returns an array' do
      expect(scraper.send(:scrape_freelancer, parsed_html_freelancer).class).to eql(Array)
    end

    it 'returns an array of hashes' do
      expect(scraper.send(:scrape_freelancer, parsed_html_freelancer)[0].class).to eql(Hash)
    end
  end

  describe '.make_url' do
    let(:freelancer) { Scraper.new(%w[any keywords], 'freelancer') }

    it 'return freelancer.com search url after taking site and page as param' do
      expect(freelancer.send(:make_url, 'freelancer', 4)).to eql('https://www.freelancer.com/jobs/4/?keyword=any%20keywords')
    end
  end

  describe '.last_page' do
    it 'return last page of freelancer.com when freelancer and parsed html is given as param' do
      expect(scraper.send(:last_page, 'freelancer', parsed_html_freelancer)).to eql(21)
    end
  end
end

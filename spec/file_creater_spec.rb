require_relative 'spec_helper.rb'
require_relative '../lib/file_creater.rb'

RSpec.describe CSVExporter do
  subject { CSVExporter.new([{ title: 'Build ruby site', rate: '$20/hr', url: 'https://url.com' }], 'freelancer') }
  describe '#export' do
    it 'checks if file is written' do
      subject.export
      expect(File.exist?('freelancer.com-jobs.csv')).to be_truthy
    end
  end
end

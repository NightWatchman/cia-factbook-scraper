$: << File.expand_path(File.dirname(__FILE__) + '/MapsDotCom/')

require 'rubygems'
require 'bundler/setup'
require 'CIAFactbookScraper/FactbookReader'

cia_html_directory = ARGV.first
unless Dir.exists? cia_html_directory
  puts "Cannot find directory #{cia_html_directory}"
  exit 1
end

Dir.open cia_html_directory do |d|
  d.each do |filename|
    if filename.end_with? '.html'
      puts "Reading #{filename}"
      STDIN.gets

      File.open File.join(d.path, filename) do |f|
        reader = MapsDotCom::CIAFactbookScraper::FactbookReader.new f
        sections = reader.sections

        sections.each { |s| puts s.to_html }
      end
    end
  end
end

#reader = MapsDotCom::CIAFactbookScraper::FactbookReader.new ARGV[0], ARGV[1]
#reader.process_all_cia_html

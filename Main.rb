$: << File.expand_path(File.dirname(__FILE__) + '/MapsDotCom/')

require 'rubygems'
require 'bundler/setup'
require 'CIAFactbookScraper/FactbookReader'
require 'CIAFactbookScraper/M101FactbookSectionRenderer'

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
        puts M101FactbookSectionRenderer.to_html sections
      end
    end
  end
end

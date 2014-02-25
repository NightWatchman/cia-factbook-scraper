$: << File.expand_path(File.dirname(__FILE__) + '/MapsDotCom/')

require 'rubygems'
require 'bundler/setup'
require 'CIAFactbookScraper/FactbookReader'
require 'CIAFactbookScraper/M101FactbookRenderer'

cia_html_directory = ARGV.first
unless Dir.exists? cia_html_directory
  puts "Cannot find directory #{cia_html_directory}"
  exit 1
end

output_dir = ARGV[1]
unless Dir.exists? output_dir
  Dir.mkdir output_dir, 0777
end

Dir.open cia_html_directory do |d|
  d.each do |filename|
    if filename.end_with? '.html'
      puts "Reading #{filename}"

      File.open(File.join(d.path, filename), 'r') do |input|
        reader = MapsDotCom::CIAFactbookScraper::FactbookReader.new input
        #sections = reader.sections

        puts "Writing #{filename}"

        File.open(File.join(output_dir, filename), 'w') do |output|
          output.puts(M101FactbookRenderer.to_html reader)
        end
      end
    end
  end
end

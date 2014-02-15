#!/usr/bin/env ruby

require 'nokogiri'
require 'StringUtilities'
require 'CIAFactbookScraper/FactbookSection'

module MapsDotCom
  module CIAFactbookScraper
    class FactbookReader
      def initialize(file)
        @file = file
      end

      def sections
        @sections ||= parse_cia_html
      end

      #def read_cia_html_directory
      #  Dir.open @input_directory do |d|
      #    d.each do |f|
      #      if f.end_with? '.html'
      #        puts "Reading #{f}"
      #        STDIN.gets
      #        parse_cia_html f
      #      end
      #    end
      #  end
      #end

      def parse_cia_html
        #filepath = File.join @input_directory, file
        #File.open filepath, 'r' do |f|
          page = Nokogiri.HTML @file

          sections = []
          category_divs = page.css 'div.category'
          category_divs.each do |c|
            #puts 'category_html: ' + c.to_html

            title = 'undefined'
            if (c.css 'a').empty?
              c.children.each do |n|
                if n.text?
                  title = n.text
                  break;
                end
              end
              #title = c.children.select { |n| n.text }.first
            else
              title = c.text
            end

            StringUtilities.collapse_whitespace! title

            # a table encapsulates each field in the CIA html
            encapsulator = c.parent
            encapsulator = encapsulator.parent while encapsulator.name != 'table'

            description = (encapsulator.css '.category_data').text
            StringUtilities.collapse_whitespace! description

            #puts 'title: ' + title
            #puts 'description: ' + description
            #puts; puts; puts

            sections << FactbookSection.new(title, description)
          end
        #end

        return sections
      end

      #def parse_base_section_children(section)
      #  cats =
      #  categories = section.css 'div.category'
      #  categories.each do |c|
      #    puts 'cat-content: ' + c.content.strip
      #    #puts 'anchor: %p' % [(c.css 'a').first]
      #    #content = (c.css 'a').first.text.strip
      #    #puts 'content: ' + content
      #  end
      #
      #  puts '--------'
      #end
    end
  end
end

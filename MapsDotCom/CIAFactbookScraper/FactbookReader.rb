require 'StringUtilities'
require 'CIAFactbookScraper/FactbookSection'

module MapsDotCom
  module CIAFactbookScraper
    class FactbookReader
      TITLE_DIV_REGEX = /<([\S]+)[^>]*class="category"[^>]*>(.*?)<\/\1>/m
      #DESCRIPTION_DIV_REGEX = /<div class="category_data">([\w\W]*?)<\/div>/m
      #DESCRIPTION_DIV_REGEX = /([^<>]+)<[^>]*class="category_data"[^>]*>(.*?)<\/[^>]*>/m
      DESCRIPTION_DIV_REGEX = /<([\S]+)[^>]*class="category_data"[^>]*>(.*?)<\/\1>/m
      def initialize(file)
        @file = file
      end

      def sections
        @sections ||= parse_cia_html
      end

      def parse_cia_html
        cia_html = @file.read
        @file.rewind

        begin
          title_match = TITLE_DIV_REGEX.match cia_html
          break if title_match.nil?

          cia_html = title_match.post_match

          description_match = DESCRIPTION_DIV_REGEX.match title_match[0]
          # This logic is pretty close, the main issue is that the description
          # for each title is duplicated as the description for the first
          # subtitle in the title section
          if description_match.nil?
            puts 'title: ' + StringUtilities.html_to_text(title_match[2])
            description_match = DESCRIPTION_DIV_REGEX.match cia_html
            puts 'description: ' + StringUtilities.html_to_text(description_match[2])
          else
            title_html = title_match[0].gsub description_match[0], ''
            puts 'subtitle: ' + StringUtilities.html_to_text(title_html)
            puts 'description: ' + StringUtilities.html_to_text(description_match[2])
          end

          #if title_match[0].include? description_match[0]
          #  title_html = title_match[0].gsub description_match[0], ''
          #  puts 'subtitle: ' + title_html
          #  puts 'description: ' + description_match[0]
          #  cia_html = title_match.post_match
          #else
          #  puts 'title: ' + title_match[2]
          #  puts 'description: ' + description_match[0]
          #  cia_html = description_match.post_match
          #end

        end while true

      #  begin
      #    title_match = TITLE_DIV_REGEX.match cia_html
      #    break if title_match.nil?
      #    #puts 'title_match: ' + title_match[0]
      #    title = StringUtilities.html_to_text title_match[1]
      #    puts 'title: ' + title
      #    cia_html = title_match.post_match
      #
      #    begin
      #      description_match = DESCRIPTION_DIV_REGEX.match cia_html
      #      break if description_match.nil?
      #      puts 'subtitle: ' + StringUtilities.html_to_text(description_match[1])
      #      puts 'description: ' + StringUtilities.html_to_text(description_match[2])
      #      puts
      #      cia_html = description_match.post_match
      #    end while true
      #
      #    puts '------'
      #  end while true
      end
    end
  end
end

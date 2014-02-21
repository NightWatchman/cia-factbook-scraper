require 'StringUtilities'
require 'CIAFactbookScraper/FactbookSection'

module MapsDotCom
  module CIAFactbookScraper
    class FactbookReader
      TITLE_DIV_REGEX = /<([\S]+)[^>]*class="category"[^>]*>(.*?)<\/\1>/m
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

        sections = []
        begin
          sections.push @section unless @section.nil?
          puts @section.inspect unless @section.nil?

          title_match = TITLE_DIV_REGEX.match cia_html
          break if title_match.nil?

          cia_html = title_match.post_match

          description_match = DESCRIPTION_DIV_REGEX.match title_match[0]
          # This logic is pretty close, the main issue is that the description
          # for each title is duplicated as the description for the first
          # subtitle in the title section
          if description_match.nil?
            description_match = DESCRIPTION_DIV_REGEX.match cia_html
            title = StringUtilities.html_to_text(title_match[2])
            description = StringUtilities.html_to_text(description_match[2])
            @section = FactbookSection.new title, description
          else
            title_html = title_match[0].gsub description_match[0], ''
            title = StringUtilities.html_to_text(title_html)
            description = StringUtilities.html_to_text(description_match[2])
            @section.add_sub_section FactbookSection.new title, description
          end
        end while true
        sections
      end
    end
  end
end

module MapsDotCom
  module CIAFactbookScraper
    class FactbookSection
      attr_accessor :title, :description, :sub_sections

      def initialize(title, description)
        @title = title
        @description = description
        @sub_sections = []
      end

      def add_sub_section(section)
        @sub_sections.push section
        @description = '' if section.description == @description
      end

      def inspect
        subs = (@sub_sections.collect { |s| s.inspect }).join ', '
        substr = subs.empty? ? '' : ", 'subs'=>'#{subs}'"
        "{'title'=>'#{@title}', 'description'=>'#{@description}'#{substr}}"
      end
    end
  end
end

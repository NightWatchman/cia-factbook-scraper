module MapsDotCom
  module CIAFactbookScraper
    class FactbookSection
      DEFINITIONS_AND_NOTES_URL = 'http://blog.maps.com/maps101-test/index.php?option=com_flexicontent&view=items&id=12721:definitions-a-notes'
      FIELD_DESCRIPTIONS_URL = '/maps101-test/index.php?option=com_flexicontent&view=items&id=12723&f=2028'
      FIELD_DESCRIPTION_ICON_URL = 'http://blog.maps.com/maps101-test/images/field_listing_on.gif'

      attr_accessor :title, :description, :sub_sections

      def initialize(title, description)
        @title = title
        @description = description
        @sub_sections = []
        freeze
      end

      def add_sub_section(section)
        @sub_sections.push section
      end

      def inspect
        description = @description
        unless @sub_sections.empty?
          description = (@sub_sections.collect { |s| s.inspect }).join ', '
        end
        "{'title'=>'#{@title}', 'description'=>'#{description}'}"
      end
    end
  end
end

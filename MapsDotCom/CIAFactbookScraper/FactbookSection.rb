module MapsDotCom
  module CIAFactbookScraper
    class FactbookSection
      DEFINITIONS_AND_NOTES_URL = 'http://blog.maps.com/maps101-test/index.php?option=com_flexicontent&view=items&id=12721:definitions-a-notes'
      FIELD_DESCRIPTIONS_URL = '/maps101-test/index.php?option=com_flexicontent&view=items&id=12723&f=2028'
      FIELD_DESCRIPTION_ICON_URL = 'http://blog.maps.com/maps101-test/images/field_listing_on.gif'

      def initialize(title, description)
        @title = title
        @description = description
      end

      def to_html
        html = Nokogiri::HTML::Builder.new do |html|
          html.div(class: 'stats-section', style: 'overflow: hidden') {
            html.div(class: 'sa-light neat_row', style: 'overflow: hidden') {
              html.div(style: 'width: 50%; float: left;') {
                html.a(href: DEFINITIONS_AND_NOTES_URL) {
                  html.text @title << ':'
                }
              }
              html.div(style: 'width: 50%; float: left; text-align: right;') {
                html.a(href: FIELD_DESCRIPTIONS_URL) {
                  html.img(src: FIELD_DESCRIPTION_ICON_URL, alt: 'Field Background: For all countries in alphabetical order')
                }
              }
            }

            html.div(class: 'category_data') {
              html.text @description
            }
          }
        end

        html.to_html.gsub /<!DOCTYPE((.|\n|\r)*?)>/, ''
      end
    end
  end
end

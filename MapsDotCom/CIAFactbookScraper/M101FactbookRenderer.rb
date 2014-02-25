require 'Nokogiri'

class M101FactbookRenderer
  DEFINITIONS_AND_NOTES_URL = 'http://blog.maps.com/maps101-test/index.php?option=com_flexicontent&view=items&id=12721:definitions-a-notes'
  FIELD_DESCRIPTIONS_URL = '/maps101-test/index.php?option=com_flexicontent&view=items&id=12723&f=2028'
  FIELD_DESCRIPTION_ICON_URL = 'http://blog.maps.com/maps101-test/images/field_listing_on.gif'
  DOCTYPE_REGEX = /<!DOCTYPE((.|\n|\r)*?)>/

  def self.to_html(factbook_reader)
    doc = Nokogiri::HTML::Builder.new do |html|
      html.p {
        html.text 'Page last updated on ' + factbook_reader.updated
      } unless factbook_reader.updated.empty?
    end
    html = doc.to_html.gsub DOCTYPE_REGEX, ''
    html << section_html(factbook_reader.sections)
  end

  def self.section_html(section)
    if section.respond_to? :each
      html = ''
      section.each { |s| html << $/ + section_html(s) }
      return html
    end

    html = Nokogiri::HTML::Builder.new do |html|
      html.div(class: 'stats-section', style: 'overflow: hidden') {
        html.div(class: 'sa-light neat_row', style: 'overflow: hidden') {
          html.div(style: 'width: 50%; float: left;') {
            html.a(href: DEFINITIONS_AND_NOTES_URL) {
              html.text section.title
            }
          }
          html.div(style: 'width: 50%; float: left; text-align: right;') {
            html.a(href: FIELD_DESCRIPTIONS_URL) {
              html.img(src: FIELD_DESCRIPTION_ICON_URL, alt: 'Field Background: For all countries in alphabetical order')
            }
          }
        }

        html.div(class: 'category_data') {
          html.text section.description
          unless section.sub_sections.empty?
            section.sub_sections.each_with_index do |s, i|
              html.br unless i == 0 && section.description.empty?
              html.span(class: 'category_data-subtitle') {
                html.text s.title + ' '
              }
              html.text s.description
            end
          end
        }
      }
    end
    html.to_html.gsub DOCTYPE_REGEX, ''
  end
end

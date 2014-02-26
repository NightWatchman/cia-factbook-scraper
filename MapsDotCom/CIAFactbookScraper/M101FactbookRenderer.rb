require 'Nokogiri'

class M101FactbookRenderer
  DEFINITIONS_AND_NOTES_URL = 'http://blog.maps.com/maps101-test/index.php?option=com_flexicontent&view=items&id=12721:definitions-a-notes'
  FIELD_DESCRIPTIONS_URL = '/maps101-test/index.php?option=com_flexicontent&view=items&id=12723&f=2028'
  FIELD_DESCRIPTION_ICON_URL = 'http://blog.maps.com/maps101-test/images/field_listing_on.gif'
  DOCTYPE_REGEX = /<!DOCTYPE((.|\n|\r)*?)>/

  def initialize(factbook_reader)
    @factbook_reader = factbook_reader
  end

  def to_html
    doc = Nokogiri::HTML::DocumentFragment.parse ''
    Nokogiri::HTML::Builder.with doc do |html|
      html.p {
        html.text 'Page last updated on ' + @factbook_reader.updated
      } unless @factbook_reader.updated.empty?

      html.text "\n\n"

      @factbook_reader.sections.each do |s|
        section_html s, doc
        html.text "\n\n"
      end
    end
    doc.to_html
  end

  private

  def section_html(section, doc)
    Nokogiri::HTML::Builder.with doc do |html|
      html << section_category_header(section)

      html.text "\n"

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
  end

  def section_category_header(section)
    category_header = Nokogiri::HTML::DocumentFragment.parse ''
    Nokogiri::HTML::Builder.with category_header do |html|
      @completed_categories ||= Hash.new(false)
      if section.title.start_with? 'Telephone'
        unless @completed_categories['comm']
          html.div(class: 'section-category') {
            html.a(name: 'comm') {
              html.text 'Communications:'
            }
          }
          @completed_categories['comm'] = true
        end
      elsif section.title.start_with? 'Airport'
        unless @completed_categories['trans']
          html.div(class: 'section-category') {
            html.a(name: 'trans') {
              html.text 'Transportation:'
            }
            @completed_categories['trans'] = true
          }
        end
      elsif section.title.start_with? 'Military'
        unless @completed_categories['military']
          html.div(class: 'section-category') {
            html.a(name: 'military') {
              html.text 'Military:'
            }
            @completed_categories['military'] = true
          }
        end
      elsif section.title.start_with?('Disputes') || \
            section.title.start_with?('Refugees') || \
            section.title.start_with?('Trafficking') || \
            section.title.start_with?('Illicit')
        unless @completed_categories['issues']
          html.div(class: 'section-category') {
            html.a(name: 'issues') {
              html.text 'Transnational Issues:'
            }
            @completed_categories['issues'] = true
          }
        end
      else
        #noinspection RubyCaseWithoutElseBlockInspection
        case section.title
          when 'Background:'
            html.div(class: 'section-category') {
              html.a(name: 'intro') {
                html.text 'Introduction:'
              }
            }
          when 'Location:'
            html.div(class: 'section-category') {
              html.a(name: 'geo') {
                html.text 'Geography:'
              }
            }
          when 'Nationality:'
            html.div(class: 'section-category') {
              html.a(name: 'people') {
                html.text 'People and Society:'
              }
            }
          when 'Country name:'
            html.div(class: 'section-category') {
              html.a(name: 'govt') {
                html.text 'Government:'
              }
            }
          when 'Economy - overview:'
            html.div(class: 'section-category') {
              html.a(name: 'econ') {
                html.text 'Economy:'
              }
            }
          when 'Electricity - production:'
            html.div(class: 'section-category') {
              html.a(name: 'energy') {
                html.text 'Energy:'
              }
            }
        end
      end
    end
    category_header.to_html
  end
end

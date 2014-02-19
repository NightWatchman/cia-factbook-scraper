module StringUtilities
  COLLAPSE_WHITESPACE_REGEX = /\s{2,}/
  HTML_TAGS_REGEX = /<[^>]*>/

  # replace all whitespace in a string with a single space
  # additionally all whitespace is removed from the beginning
  # and the end
  def self.collapse_whitespace!(string)
    string.strip!
    string.gsub! COLLAPSE_WHITESPACE_REGEX, ' '
  end

  def self.collapse_whitespace(string)
    string.strip.gsub COLLAPSE_WHITESPACE_REGEX, ' '
  end

  def self.strip_html_tags(string)
    string.gsub HTML_TAGS_REGEX, ''
  end

  def self.html_to_text(string)
    string = self.strip_html_tags string
    self.collapse_whitespace string
  end
end

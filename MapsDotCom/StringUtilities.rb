module StringUtilities
  COLLAPSE_WHITESPACE_REGEX = /\s{2,}/

  # replace all whitespace in a string with a single space
  # additionally all whitespace is removed from the beginning
  # and the end
  def self.collapse_whitespace! string
    string.strip!
    string.gsub! COLLAPSE_WHITESPACE_REGEX, ' '
  end

  def self.collapse_whitespace
    strip.gsub COLLAPSE_WHITESPACE_REGEX, ' '
  end
end

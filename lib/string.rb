class String
  def url_encode
    CGI::escape self
  end

  def url_decode
    CGI::unescape self
  end

  def methodize
    scan(/[a-z]+/i).join("_").downcase rescue ''
  end

  # Some of this is Taken from https://github.com/rsl/stringex
  def to_url
    s = self.strip
    {
      /\<3/ => '-love-',
      /(\s|^)\$(\d+)\.(\d+)(\s|$)/ => '-\2 dollars \3 cents-',
      /\s*&\s*/ => '-and-',
      /\s*#/ => '-number-',
      /\s*@\s*/ => '-at-',
      /(\s|^)\$(\d*)(\s|$)/ => '-\2 dollars-',
      /\s*\*\s*/ => '-star-',
      /\s*%\s*/ => '-percent-',
      /(\s*=\s*)/ => '- equals -',
      /\s*\+\s*/ => '-plus-',
      /\W+/ => ' ',
      /[\s]+/ => '-',
    }.each { |search,replace| s = s.strip.gsub(search,replace) }
    s.downcase
  end

  def distance match
    dist = Levenshtein.distance(self,match)
    dist.to_f / self.length.to_f
  end

end


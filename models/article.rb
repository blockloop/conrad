class Article < Unhashable

  def initialize filepath=""
    raise ArgumentError, "filepath doesn't exist" unless File.exists? filepath
    self[:file_path] = filepath
    load
    self[:permalink] = make_permalink
    unhash!
  end

  # lazy loaded
  def body
    return self[:body] if self[:body] and not development?
    raw = File.readlines(self[:file_path])[CONFIG[:header_length]..-1].join
    self[:body] = RedCloth.new(raw).to_html if File.extname(self[:file_path]) == '.textile'
    self[:body] ||= RDiscount.new(raw).to_html
    self[:body]
  end

  private
    def load
      path = File.expand_path self[:file_path]
      lines = ["file_path: '#{path}'"]

      File.readlines(path).each do |line|
        break if line.strip.empty? # stop after header
        lines.push line
      end 
      
      merge! YAML.load(lines.join("\n")).symbolize_keys
      each { |k,v| raise LoadError, "Missing #{k.to_s} for #{File.basename article[:file_path]}" unless v }
    end

    def make_permalink
      year = self[:date].year.to_s
      month = self[:date].month.two_digit
      day = self[:date].day.two_digit
      "/" + [year,month,day,self[:title].to_url].join('/').strip
    end

end
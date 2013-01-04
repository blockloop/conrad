class Article < Unhashable

  def initialize filepath=""
    raise ArgumentError, "filepath doesn't exist" unless File.exists? filepath
    self[:file_path] = File.expand_path filepath
    load
    unhash!
  end

  # lazy loaded
  def body
    return @body if @body and not development?
    raw = File.readlines(self[:file_path])[CONFIG[:header_length]..-1].join
    @body = RedCloth.new(raw).to_html if File.extname(self[:file_path]) == '.textile'
    @body ||= RDiscount.new(raw).to_html
  end

  private
    def load
      lines=[]
      File.readlines(self[:file_path]).each do |line|
        break if line.strip.empty? # stop after header
        lines.push line
      end 
      
      merge! YAML.load(lines.join("\n")).symbolize_keys
      each { |k,v| raise LoadError, "Missing #{k.to_s} for #{File.basename article[:file_path]}" unless v }
      self[:permalink] = make_permalink
    end

    def make_permalink
      year = self[:date].year.to_s
      month = self[:date].month.two_digit
      day = self[:date].day.two_digit
      "/" + [year,month,day,self[:title].to_url].join('/').strip
    end

end
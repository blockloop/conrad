# encoding: utf-8
# def spoof_request uri,env_modifications={}
# 	call(env.merge("PATH_INFO" => uri).merge(env_modifications)).last.join
# end

def partial page, variables={} 
	haml :"partials/#{File.basename page.to_s}", variables
end

def gravatar_for email, options = {}
  options = {:alt => 'avatar', :class => 'avatar', :size => 80}.merge! options
  id = Digest::MD5::hexdigest email.strip.downcase
  url = "http://www.gravatar.com/avatar/#{id}.jpg?s=#{options[:size].to_s}"
  options.delete :size
  options_str = options.map{ |k,v| "#{k}='#{v}'" }.join(' ')
  "<img src='#{url}' #{options_str} />"
end

def twitter_enabled
  SETTINGS[:twitter] and SETTINGS[:twitter].to_a.none? { |k,v| v.nil? }
end

def tweets
  return CACHE[:tweets] if CACHE[:tweets] and CACHE[:tweets_expire] > Time.now
  handle = SETTINGS[:twitter][:handle]
  count = SETTINGS[:twitter][:tweet_count]
  t = Twitter.user_timeline(handle, :count => count)
  CACHE[:tweets] = t
  CACHE[:tweets_expire] = Time.now + (10*60) # 10 minutes
  t
end

def make_permalink article
  year = article[:date].year.to_s
  month = article[:date].month.two_digit
  day = article[:date].day.two_digit
  "/" + [year,month,day,article[:title].to_url].join('/').strip
end

def find_article permalink
  article = CACHE[:articles].find { |a| a[:permalink] == permalink.strip }
  nil unless article
  article[:content] = load_content article[:file_path] unless article[:content]
  article
end

def skim_articles
  Dir["#{SETTINGS[:content_path]}/*"].map { |f|
    path = File.expand_path f
    lines = ["file_path: '#{path}'"]

    File.readlines(path).each do |line|
      break if line.strip.empty? # stop after header
      lines.push line
    end 
    
    article = YAML.load(lines.join("\n")).symbolize_keys
    article.each { |k,v| raise LoadError, "Missing #{k.to_s} for #{File.basename article[:file_path]}" unless v }
    article[:permalink] = make_permalink article
    article
  }.
  sort { |a,b| b[:date] <=> a[:date] }
end

def load_content file_path
  raw = File.readlines(file_path)[CONFIG[:header_length]..-1].join
  return RedCloth.new(raw).to_html if File.extname(file_path) == '.textile'
  return RDiscount.new(raw).to_html
end




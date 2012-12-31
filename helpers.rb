# encoding: utf-8
# def spoof_request uri,env_modifications={}
# 	call(env.merge("PATH_INFO" => uri).merge(env_modifications)).last.join
# end

def partial page, variables={} 
	haml page, {layout:false}, variables
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
  d = article[:date]
  "/" + [d.year, d.month, d.day, article[:title].to_url].join('/').strip
end

def find_article permalink
  article = CACHE[:articles].find { |a| a[:permalink] == permalink.strip }
  nil unless article
  article[:content] = load_content article[:file_path] unless article[:content]
  article
end

def skim_articles
  Dir["#{SETTINGS[:content_path]}/*.textile"].map { |f|
    path = File.expand_path f
    lines = ["file_path: '#{path}'"]

    File.readlines(path).each do |line|
      break if line.strip.empty? # stop after header
      lines.push line
    end 
    
    article = YAML.load(lines.join("\n")).symbolize_keys
    article[:permalink] = make_permalink article
    article
  }.
  sort { |a,b| b[:date] <=> a[:date] }
end

def load_content file_path
  raw = File.readlines(file_path)[HEADER_LENGTH..-1].join
  RedCloth.new(raw).to_html
end




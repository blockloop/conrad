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
  SETTINGS[:twitter] and 
  SETTINGS[:twitter][:handle] and SETTINGS[:twitter][:tweet_count] and
  SETTINGS[:twitter][:consumer_key] and SETTINGS[:twitter][:consumer_secret] and
  SETTINGS[:twitter][:access_token] and SETTINGS[:twitter][:access_token_secret]
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

def make_permalink title,date
  "/#{date.year}/#{date.month}/#{date.day}/#{title.to_permalink}"
end

def find_article title,date
  all = Dir["#{SETTINGS[:content_path]}/*.textile"].map { |a| 
    scan_article(File.expand_path a)
  }.find_all { |a| a[:date] == date }

  return read_article all.first[:file_path] if all.one? and (all.first[:title].distance(title) < 0.3)

  by_title = all.map{ |a| 
    {:article => a, :distance => a[:title].distance(title)} 
  }.find_all{|a| a[:distance] < 0.3}
  
  return read_article by_title.first[:file_path] if by_title.one? 
  
  best_fit = by_title.sort{ |x,y| 
    x[:distance] <=> y[:distance]
  }.first[:article][:file_path]
  
  read_article best_fit
end

def scan_article file_path
  lines = ["file_path: '#{file_path}'"]
  i = 0
  File.readlines(file_path).each do |line|
    break if i == 2
    lines.push line
    i+=1
  end 
  YAML.load(lines.join("\n")).symbolize_keys
end

def read_article file_path
  file_lines = File.readlines(file_path)
  header = file_lines[0..1]
  timestamp = header.last.split(':').last.strip
  date = DateTime.parse(timestamp)
  title = header.first.split(':').last.strip
  raw = file_lines[2..-1].join().strip

  article = {}
  article[:content] = RedCloth.new(raw).to_html
  article[:title] = title
  article[:date] = DateTime.new(date.year,date.month,date.day)
  article[:link] = make_permalink title,article[:date]
  article
end


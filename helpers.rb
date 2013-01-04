# encoding: utf-8
# def spoof_request uri,env_modifications={}
# 	call(env.merge("PATH_INFO" => uri).merge(env_modifications)).last.join
# end

def partial page
	haml :"partials/#{File.basename page.to_s}"
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
  [SETTINGS[:twitter][:handle],
    SETTINGS[:twitter][:tweet_count],
    SETTINGS[:twitter][:consumer_key],
    SETTINGS[:twitter][:consumer_secret],
    SETTINGS[:twitter][:access_token],
    SETTINGS[:twitter][:access_token_secret]].all? rescue false
end

def tweets
  return nil unless twitter_enabled
  return CACHE[:tweets] if CACHE[:tweets] and CACHE[:tweets_expire] > Time.now
  handle = SETTINGS[:twitter][:handle]
  count = SETTINGS[:twitter][:tweet_count]
  t = Twitter.user_timeline(handle, :count => count)
  CACHE[:tweets_expire] = Time.now + (10*60) # 10 minutes
  CACHE[:tweets] ||= t
end

def find_article permalink
  CACHE[:articles].find { |a| a[:permalink] == permalink.strip }
end

def get_articles count=-1,offset=0
  last = offset + count
  CACHE[:articles][offset..last] || []
end

def skim_articles
  Dir["#{SETTINGS[:content_path]}/*"].map{ |f| Article.new f }.
  sort{ |a,b| b[:date] <=> a[:date] }
end

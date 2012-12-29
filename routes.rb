get "/" do
  file_path = File.expand_path SETTINGS[:content_path]
	articles = Dir["#{file_path}/*.textile"].map { |a| read_article a }.sort { |a,b| b[:date] <=> a[:date] }
  @articles = articles
  @disqus = false
  haml :main
end

# Articles
article_reg = /\d{4}\/\d{2}\/\d{2}\/.+/i

get '/:year/:month/:day/:title' do
  raise ArgumentError, "Path is not valid." unless request.path_info =~ article_reg
  p_link = request.path_info
  article = nil
  article = CACHE[p_link] if CACHE[p_link] and settings.production? and SETTINGS[:article_cache]

  unless article # not cached
    title = params[:title]
    title.gsub!(/\W+/, '-')
    title.gsub!(/-+/, ' ')
    date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    article = find_article title,date
    CACHE[p_link] = article
  end

  @article = article
  @title = @article[:title]
  @disqus = SETTINGS[:disqus_shortname]
  haml :article
end


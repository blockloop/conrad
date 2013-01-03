get "/" do
  file_path = File.expand_path SETTINGS[:content_path]
  articles = CACHE[:articles][0..4]
  @articles = articles
  @disqus = false
  haml :main
end

get '/:year/:month/:day/:title' do
  article = find_article request.path_info
  error 404 unless article
  @article = article
  @title = @article[:title]
  @disqus = SETTINGS[:disqus_shortname]
  haml :article
end


get "/" do
  file_path = File.expand_path SETTINGS[:content_path]
  @articles = get_articles 5
  @disqus = false
  haml :main
end

get '/archive/?:page?' do
  @page = params[:page].to_i rescue 1
  count = 10
  offset = @page > 1 ? page*count : 0
  @articles = get_articles count,offset
  @pages = (get_articles.count / count).ceil
  @title = 'Archive'
  haml :archive
end

get '/:year/:month/:day/:title' do
  article = find_article request.path_info
  error 404 unless article
  @article = article
  @title = @article[:title]
  @disqus = SETTINGS[:disqus_shortname]
  haml :article
end


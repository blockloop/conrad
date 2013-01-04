require 'rake'
require 'httparty'
require 'uri'

namespace "theme" do
  
  desc "Install a theme"
  task :install do
    exit_with_message "Please provide a theme name to install" if ARGV.one?
    theme = ARGV.last.downcase
    install_bootstrap theme
  end

end

def exit_with_message msg,code=0
  p msg
  exit code
end

def install_bootstrap theme
  source = "https://raw.github.com/thomaspark/bootswatch/gh-pages/#{theme}/bootstrap.min.css"
  dest = 'public/css/bootstrap.min.css'
  install_css source,dest
end

def install_css source,dest
  css = read_css source
  IO.write(dest, css)
end

def read_css source
  if url? source
    response = HTTParty.get(source)
    exit_with_message("CSS not found!! Error: #{response.code} #{response.message}",1) unless response.code == 200
    response.body
  else
    nil
  end
end

def url? url
  uri = URI.parse(url)
  uri.kind_of?(URI::HTTP)
rescue URI::InvalidURIError
  false
end

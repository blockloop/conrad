require 'rake'
require 'httparty'
require 'less'
require 'uri'

namespace "theme" do
  
  desc "Install a theme"
  task :install do
    exit_with_message "Please provide a theme name to install" if ARGV.one?
    theme = ARGV.last.downcase rescue nil
    install_bootstrap theme
    download_variables theme
    compile_styles
    exit_with_message "Theme installed successfully => #{theme}"
  end

  desc "Compile less"
  task :compile do
    compile_styles
    exit_with_message "Successfully compiled"
  end

end

def exit_with_message msg,code=0
  p msg
  exit code
end

def install_bootstrap theme
  source = "https://raw.github.com/thomaspark/bootswatch/gh-pages/#{theme}/bootstrap.min.css"
  dest = File.expand_path 'public/css/bootstrap.min.css'
  install_css source,dest
end

def download_variables theme
  # p "Downloading variables for #{theme}"
  source = "https://raw.github.com/thomaspark/bootswatch/gh-pages/#{theme}/variables.less"
  dest = File.expand_path 'public/css/less/variables.less'
  install_css source,dest
end

def compile_styles
  # p "Compiling styles..."
  parser = Less::Parser.new # :paths => ['./public/css/'], :filename => 'style.css'
  # p "reading less file"
  less = IO.read File.expand_path('public/css/less/variables.less')
  less += IO.read File.expand_path('public/css/less/style.less')
  # p "Less read: #{less[0..50]} ..."
  # p "Attempting to parse less ..."
  tree = parser.parse(less)
  style_css = tree.to_css(:compress => true)
  # p "Parsed and read: #{style_css}"
  IO.write(File.expand_path('public/css/style.css'), style_css)
end

def install_css source,dest
  # p "Installing css from #{source}..."
  css = read_css source
  # p "Writing css to #{dest}..."
  IO.write(dest, css)
end

def read_css source
  if url? source
    # p "Reading CSS from #{source}..."
    response = HTTParty.get(source)
    exit_with_message("CSS not found!! Error: #{response.code} #{response.message}",1) unless response.code == 200
    # p "CSS received: #{response.body[0..50]}..."
    response.body
  else
    nil
  end
end

def url? url
  begin
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end
end







require 'rake'
require 'httparty'

namespace "theme" do
  
  desc "Install a theme"
  task :install do
    exit_with_message "Please provide a theme name to install" if ARGV.one?
    theme = ARGV.last.downcase rescue nil
    response = HTTParty.get("https://raw.github.com/thomaspark/bootswatch/gh-pages/#{theme}/bootstrap.min.css")
    exit_with_message("Theme not found!! Error: #{response.code} #{response.message}",1) unless response.code == 200
    css = response.body
    IO.write('public/css/bootstrap.min.css', css)
    exit_with_message "Theme installed successfully => #{theme}"
  end

end

def exit_with_message msg,code=0
  p msg
  exit code
end
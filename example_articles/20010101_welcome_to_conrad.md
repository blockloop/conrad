title: Welcome To Conrad!
date: 2012-12-20

Conrad is a simple blog framework written with [Sinatra][sinatra] and utilizes user friendly libraries such as [Textile][textile] and [Markdown][markdown]. 

Live Example: [http://conrad.herokuapp.com](http://conrad.herokuapp.com)


### Features

-   ~30Kb in size (not including bootstrap and jquery)
-   Text file based blogs written with [textile] and [markdown]
-   Installable themes from [bootswatch][]! (see *Themes* section below)
-   Responsive design thanks to Bootstrap (optional)
    -   Looks great on all devices!
-   Twitter feed sidebar (optional)
-   Disquis integration (optional)
-   [Heroku][heroku] ready! simply bundle, init and push
-   Caching
    -   Blog content is cached until restart by default (great for
        [heroku][] since server is restarted when a new article is
        published and pushed).
    -   Twitter feed is cached for 10 minutes

### Configure

Configure by renaming the config.example.yml file in the root directory to config.yml and configuring. There you will find instructions and settings used in this application. Settings marked as *OPTIONAL* can be commented out to exclude from the application. If a setting is not marked as *OPTIONAL* then not setting it will probably cause issues.

### Writing

Writing articles in Conrad is extremely simple. If you’re unfamiliar with textile (or markdown) it’s an easy concept that significantly cuts down the writing time. You can [read about the textile here][textile] or [markdown here][markdown].

When you’re writing a new article there are only two things required. You must write the title and date at the very top of the page in the following format. You must write **“Title:”** and **“Date:”** on two different lines and they must look exatly like this (case insensitive):

> Title: Welcome To Conrad!  
> Date: 2001-01-01  
> 
> Start writing here…

### Themes

Themes from [bootswatch][] are easily installed with a single line of code

    rake theme:install [theme name]

eg. 

    rake theme:install journal

### How To Use

    $ git clone git@github.com:brettof86/conrad.git  
    $ cd conrad  
    $ bundle install  
    $ ruby app.rb

Then Navigate to [http://localhost:4567](http://localhost:4567)

This will run with default settings. To customize, create rename config.example.yml to config.yml and add your own custom details and (re)start the application.


### Free web hosting via Heroku

[Setup your Heroku account](https://devcenter.heroku.com/articles/quickstart)
clone and configure (see *How To Use* above)

    $ cd conrad  
    $ heroku create blogname  
    $ git push heroku master
  

  [sinatra]: http://sinatrarb.com
  [textile]: http://redcloth.org
  [markdown]: http://daringfireball.net/projects/markdown/syntax
  [heroku]: http://heroku.com
  [bootswatch]: http://bootswatch.com
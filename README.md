Conrad is a simple blog framework written with [sinatra][] and [Textile (RedCloth)][]

### Features

-   Text file based blogs written with textile (RedCloth)
-   Installable themes from [bootswatch][]! (see themes below)
-   Responsive design thanks to Bootstrap
    -   Looks great on all devices!
-   Twitter feed sidebar (optional)
-   Disquis integration (optional)
-   Heroku ready! simply bundle, init and push
-   Caching
    -   Blog content is cached until restart by default (great for
        [heroku][] since server is restarted when a new article is
        published).
    -   Twitter feed is cached for 10 minutes

### Configure

Configure this by editing config.yml file in the root directory. There you will find instructions and settings used in this application. Settings marked as *OPTIONAL* can be commented out to exclude from the application. If a setting is not marked as *OPTIONAL* then not setting will probably cause issues in the application.

### Writing

Writing articles in Conrad are extremely simple. If you’re unfamiliar with textile it’s an easy concept that significantly cuts down the writing time. You can [read about the syntax here][Textile] or read this article under the articles directory in the root path of the project.

When you’re writing a new article there are only two things required. You must write the title and date at the very top of the page in the following format. You must write **“Title:”** and **“Date:”** on two different lines and they must look exatly like this:

> Title: Welcome To Conrad!  
> Date: 2001-01-01  
> 
> Start writing here…

### Themes

Themes from bootswatch are easily installed with a single line of code

> rake theme:install [theme name]

eg. 

> rake theme:install journal

### How To Install

```bash
$ git clone git@github.com:brettof86/conrad.git  
$ cd conrad  
$ bundle install  
$ ruby app.rb
```

This will run with default settings. Once you’re ready, edit config.yml to add your own custom details and start the application again.

  [sinatra]: http://sinatrarb.com
  [Textile]: http://redcloth.org
  [heroku]: http://heroku.com
  [bootswatch]: http://bootswatch.com

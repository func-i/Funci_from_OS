functional imperative dot com
=============
##### design by [objective subject](http://objectivesubject.com)


### development

* `bundle install`
* `bundle exec rake`
* Browse to `http://localhost:4000`


### staging

* need to use/create a repo outside the func-i GitHub account (FI website on GitHub Pages is an User/Organizatin page, and it has a CNAME file re-directing to www.functionalimperative.com, which also affects every project page on the func-i account)
* `bundle exec rake 'staging[<github_user>, <github_repo_name>]'`


### deployment

* ensure you've enabled the production options in `_config.yml` like so:
```
  ##### production  #####

  debug: true
  cachebust: none
  gzip: true
  js_compressor: uglifier
  css_compressor: yui
```

* checkout out the project git@github.com:func-i/func-i.github.com.git
    * This is the actual Funci website project
    * The location to this project will be your: path_to_local_gh_pages_repo
* commit your changes locally
* `bundle exec rake deploy[<path_to_local_gh_pages_repo>]`


### Notes

* auto-generates sitemap: _site/sitemap.xml

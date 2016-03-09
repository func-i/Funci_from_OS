functional imperative dot com
=============
##### design by [objective subject](http://objectivesubject.com)


### development

* `bundle install`
* `bundle exec rake`
* Browse to `http://localhost:4000`


### staging

* `bundle exec rake staging`
* Browse to `http://www.functionalimperative.com/Funci_from_OS/`


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

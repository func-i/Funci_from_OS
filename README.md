functional imperative dot com
=============
##### design by [objective subject](http://objectivesubject.com)


### development

* `bundle install`
* Open `_config.yml`:
    - enable the **development** options:
    ```
      ##### development #####

      debug: true
      cachebust: hard
      gzip: false
      js_compressor: none
      css_compressor: none
    ```
    - disable the **staging** and **production** options
    ```
      ##### staging #####
      # url: http://fi-website-staging.s3-website-us-east-1.amazonaws.com

      ##### production #####
      # url: http://www.functionalimperative.com

      ##### production  #####

      # debug: true
      # cachebust: none
      # gzip: true
      # js_compressor: uglifier
      # css_compressor: yui
    ```
* `bundle exec rake`
* Browse to `http://localhost:4000`


### staging

* Open `_config.yml`:
    - enable the **staging** and **production** options
    - disable the **development** options
* `bundle exec rake staging`
* Browse to `http://fi-website-staging.s3-website-us-east-1.amazonaws.com/`


### deployment

* Open `_config.yml`:
    - enable the **production** options
    - disable the **staging** and **development** options
* checkout out the project git@github.com:func-i/func-i.github.com.git
    * This is the actual Funci website project
    * The location to this project will be your: path_to_local_gh_pages_repo
* commit your changes locally
* `bundle exec rake deploy[<path_to_local_gh_pages_repo>]`


### Notes

* auto-generates sitemap: _site/sitemap.xml
* For each blog post, specify the image and description (for sharing on social media) in the top of the Markdown document. See `_posts/2015-10-15-three-js.md` for an example.
    - if no social_image is specified, `blog_posts/social_default.jpg` will be used

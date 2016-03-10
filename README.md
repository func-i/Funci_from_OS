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
    - disable the **staging** options
    ```
      ##### staging #####
      # staging_dir: "/Funci_from_OS"

      assets:
        ##### staging #####
        # prefix: "/Funci_from_OS/assets"
    ```
    - disable the  **production** options
    ```
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
    - enable the **staging** options
    - enable the **production** options
    - disable the **development** options
* `bundle exec rake staging`
* Browse to `http://www.functionalimperative.com/Funci_from_OS/`


### deployment

* Open `_config.yml`:
    - enable the **production** options
    - disable the **development** options
    - disable the **staging** options
* checkout out the project git@github.com:func-i/func-i.github.com.git
    * This is the actual Funci website project
    * The location to this project will be your: path_to_local_gh_pages_repo
* commit your changes locally
* `bundle exec rake deploy[<path_to_local_gh_pages_repo>]`


### Notes

* auto-generates sitemap: _site/sitemap.xml

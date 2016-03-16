functional imperative dot com
=============
##### design by [objective subject](http://objectivesubject.com)


## Development

* `bundle install`
* `bundle exec rake`
* Browse to `http://localhost:4000`


## Deploy

Push to the `staging` or `master` branch will trigger an auto-build on [Heroku server](https://github.com/tfchang/fi-website-autobuild), which will deploy the built site to the staging (`fi-website-staging`) or production (`fi-website`) bucket on Amazon S3.

### Staging

* push to the `staging` branch on GitHub
* wait (~20 seconds)
* Browse to `http://fi-website-staging.s3-website-us-east-1.amazonaws.com/`

### Production

* *Recommended Process:* Do not push to master directly. Work on GitHub.
* Developers: Test any change on staging first. Make pull request from staging to master. Merging a pull request equals a push.
* Page/post editors: Edit a page or a blog post on GitHub. Commiting the changes equals a push.
* wait (~20 seconds)
* Browse to `http://www.functionalimperative.com/`


## Notes

* auto-generates sitemap: _site/sitemap.xml
* For each blog post, specify the image and description (for sharing on social media) in the top of the Markdown document. See `_posts/2015-10-15-three-js.md` for an example.
    - if no social_image is specified, `blog_posts/social_default.jpg` will be used

functional imperative dot com
=============
##### design by [objective subject](http://objectivesubject.com)


## Development

* `bundle install`
* `bundle exec rake`
* Browse to `http://localhost:4000`


## Deploy

Pushing to the `staging` or `master` branch will trigger an auto-build on the [Heroku server](https://github.com/func-i/fi-site-autobuild), which will deploy the built site to the staging (`fi-website-staging`) or production (`fi-website`) bucket on Amazon S3.

**Important**: Do not undo commits with `git reset` followed by a force push like `git push origin +staging` - it will mess up the auto-build server. Always make a new commit to undo changes, or use `git revert`.

**Important**: the Gemfile of the [auto-build server on Heroku](https://github.com/func-i/fi-site-autobuild) must contain all the gems in the Gemfile of this repo. If you update the Gemfile here, make sure to apply the same changes to the Gemfile of the auto-build server repo and push to Heroku there before you push to `staging` or merge into `master` here.


### Staging

* push to the `staging` branch on GitHub
* wait (30-60 seconds)
* Browse to `http://fi-website-staging.s3-website-us-east-1.amazonaws.com/`

### Production

* *Recommended Process:* Do not push to `master` directly. Work on GitHub.
    - Developers: Test any change on `staging` first. Make pull request from `staging` to `master`. Merging a pull request equals a push.
    - Page/post editors: Upload/edit a page or blog post on `master`. Commiting the changes equals a push.
* wait (30-60 seconds)
* Browse to `http://www.functionalimperative.com/`


## Notes

* auto-generates sitemap: _site/sitemap.xml
* For each blog post, specify the image and description (for sharing on social media) in the top of the Markdown document. See `_posts/2015-10-15-three-js.md` for an example.
    - if no social_image is specified, `blog_posts/social_default.jpg` will be used

functional imperative dot com
=============
##### design by [objective subject](http://objectivesubject.com)


## Development

* `bundle install`
* `bundle exec rake`
* Browse to `http://localhost:4000`


## Deploy

Pushing to the `staging` or `master` branch will trigger an auto-build on the [Heroku server](https://github.com/func-i/fi-site-autobuild), which will deploy the built site to staging or production on Amazon S3.

**Important**: Do not undo commits with `git reset` followed by a force push like `git push origin +staging` - it will mess up the auto-build server. Always make a new commit to undo changes, or use `git revert`.

**Important**: the Gemfile of the [auto-build server on Heroku](https://github.com/func-i/fi-site-autobuild) must contain all the gems in the Gemfile of this repo. If you update the Gemfile here, make sure to apply the same changes to the Gemfile of the auto-build server repo and push to Heroku there before you push to `staging` or merge into `master` here.


### Staging

* push to the `staging` branch on GitHub
* wait (30-60 seconds)
* Browse to `http://fi-website-staging.s3-website-us-east-1.amazonaws.com/`

### Production

* *Recommended Process:* Do not push to `master` from command line. Work on GitHub.
    - Developers: Test any change on `staging` first. Make pull request from `staging` to `master`. Merging a pull request equals a push.
    - Editors: On `master`, edit a page/post or upload a post/asset (eg. image). Commiting the change equals a push.
    - Upload assets for use on the website to the /_assets folder
    - Upload images that aren't used on the website to the /offsite-assets/images folder. The images can be referenced at `http://functionalimperative.com/offsite-assets/images/[filename]`
* wait (30-60 seconds)
* Browse to `http://functionalimperative.com/`


## Notes

* auto-generates sitemap: _site/sitemap.xml
* For each blog post, specify the image and description (for sharing on social media) in the top of the Markdown document. See `_posts/2015-10-15-three-js.md` for an example.
    - if no social_image is specified, `blog_posts/social_default.jpg` will be used

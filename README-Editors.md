Instructions for Editors
========================

1. Work on GitHub, the `master` branch
2. Edit a page/post or upload a post/asset (eg. image), then commit the change
    - Upload/edit blog posts in the `/_posts` folder
    - Upload assets for use on the website to the `/_assets` folder
    - Upload images that aren't used on the website to the `/offsite-assets/images` folder. The images can be referenced at `http://functionalimperative.com/offsite-assets/images/[filename]`
3. wait 60 seconds
4. Browse to `http://functionalimperative.com/`

testing 6

### Blog Posts

At the top of each post is a section called "front matter" enclosed in ---
```
---
layout:     post
title:      Experimenting With Three.js and WebGL
author:     bruno
date:       2015-10-15
published:  true
social_image: blog_posts/2015-10-15-three-js/social
description: I recently graduated from Lighthouse Labs, and as my final project ...
---
```
Specify social media sharing and SEO-related settings here:
* `social_image` is path to the display image when the post is shared on social media
    - the path is relative to the `/_assets/images/` folder
    - if `social_image` is not specified, `blog_posts/social_default.jpg` will be used
* `description` is the excerpt to be displayed on social shares and also used for SEO


### Pages (Home, About, Contact, etc.)

Each page is composed of "partial" components. If you can't find the content you want to edit, consult the developers.

#### Email capture component on a page

To add a email form component to a page:
* add `{% include partials/mail_form.html %}` into the page where you want the form to be
* in the front matter of that page, set the `mail_list` and `mail_ask` fields
    - `mail_list` is the [MailChimp List ID](http://kb.mailchimp.com/lists/managing-subscribers/find-your-list-id) of the mailing list you want the reader to subscribe to. *8c83af5a31* (info@functionalimperative.com) if not specified
    - `mail_ask` is the text asking for subscription. *Subscribe to our mailing list* if not specified




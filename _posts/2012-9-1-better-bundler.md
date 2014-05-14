---
layout:     post
title:      Better Bundler
subtitle:   Bundler gets better local gem support
author:     jon
date:       2012-9-1 16:21:22
---

There are times when developing that we need to tweak a gem to better suit our needs.   Consider the following Gemfile:

{% highlight ruby %}

gem 'nokogiri'

{% endhighlight %}

This will fetch the latest Nokogiri tag from RubyGems and install it in your $GEM_PATH.  What if you want to modify the nokogiri gem and submit a pull request?

{% highlight ruby %}

gem 'nokogiri', :git => 'git@github.com:Sailias/nokogiri.git'

{% endhighlight %}

This will use my fork of nokogiri, but how would I do development on it?  I can clone it, push changes back to my fork, then bundle update. If I commit some bad code, I will end up cluttering my commit log with garbage, so this approach is not even a real option.
What we really need to do is include a local version of our gem in our project.

### Here comes :path

{% highlight ruby %}

gem 'nokogiri', :path => '/path/to/nokogiri'

{% endhighlight %}

Up until now, using the path option was the recommended approach. This will use a local repository where I can freely modify it as I see fit.  From there I can commit and push my changes up.

This approach does come with some drawbacks, though.

Once included in your Gemfile, all developers will now have to install a local version of this gem in the path specified, even if they don't plan on modifying the gem like you do. This means the Gemfile is no longer production ready, the app can break and you now have a file that cannot be committed.  You could also run into path problems depending on your platform. What if we could still use a local gem <em>if we wanted to</em> and also allow the user to specify the location? A common problem that was [discussed recently](https://gist.github.com/2063855), which resulted in...

### Bundler's latest answer

Recent [commits](https://github.com/carlhuda/bundler/pull/1779) from [José Valim](https://github.com/josevalim) to bundler have added functionality to configure local paths for each gem.

{% highlight bash %}

# in your project folder
$> bundle config local.nokogiri /path/to/local/nokogiri

{% endhighlight %}

{% highlight ruby %}

gem 'nokogiri', :git => 'git@github.com:Sailias/nokogiri.git', :branch => 'master'

{% endhighlight %}

That's it! Bundler has now been configured to use the version of nokogiri at the specified location! This feature only works for git dependencies and the branch option is required because it will match up with the branch in the local path to ensure your local gem isn't on another branch. You can also switch between branches of this gem using this functionality.

Bundler will work just like path and will still load your local changes, but will also keep track of the current revision in your Gemfile.lock in order to stay in sync with remote changes. This is a much more dynamic approach than :path, which allows each user to control their config, yet still keeps the simplicity that makes bundler *amazing*.
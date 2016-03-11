---
layout:     post
title:      Name your Regexp match captures!
subtitle:   More expressive and maintainable MatchData
author:     alex
date:       2015-05-15
published:  true
description: You know that weird Ruby MatchData object? Sure, it acts like an array, but it doesn't feel like one. And when you're capturing several matches, it can be cumbersome to decipher which index correlates to each capture. And what happens when you add a new match capture? You have to shift your others around!
---

You know that weird Ruby [`MatchData`](http://ruby-doc.org/core-2.2.0/MatchData.html) object? Sure, it acts like an array, but it doesn't feel like one. And when you're capturing several matches, it can be cumbersome to decipher which index correlates to each capture. And what happens when you add a new match capture? You have to shift your others around!

Let's take an example from one of my current projects.

### Pain points

I need to parse out a domain name into subdomain and parent domain. Easy candidate for Regexp of course. Here's a typical solution:

<figure>
  {% highlight ruby %}
    parsed_domain = "alex.func-i.com".match /(.+)\.(.+\..+)/
  {% endhighlight %}
</figure>

Quick, how would we access the parent domain here? You took too long!

<!--more-->

That's because you first had to remind yourself that index `0` holds the full matched string:

<figure>
  {% highlight ruby %}
      parsed_domain[0]
      => "alex.func-i.com"
  {% endhighlight %}
</figure>

Then you had to literally count your match captures to figure out that the parent domain is at index `2`. Even worse, since this isn't code that you wrote, you would need to spend at least a few seconds deciphering the Regexp itself to understand where the parent domain would be:

<figure>
  {% highlight ruby %}
      parsed_domain[2]
      => "func-i.com"
  {% endhighlight %}
</figure>

### A better way

Okay, same challenge: access the parent domain from the `parsed_domain` variable. Ready? Go!

<figure>
  {% highlight ruby %}
      parsed_domain = "alex.func-i.com".match /(?<subdomain>.+)\.(?<parent_domain>.+\..+)/
  {% endhighlight %}
</figure>

Showoff! Now instead of trying to count indeces and decipher a Regexp, you can simply try the following:

<figure>
  {% highlight ruby %}
      parsed_domain[:parent_domain]
      => "func-i.com"
  {% endhighlight %}
</figure>

Notice the unusual but incredibly helpful [`?<variable_name>` Regexp syntax](http://ruby-doc.org/core-2.2.0/Regexp.html#class-Regexp-label-Capturing) that allows us to expressively access our match captures through a Hash-like `[:variable_name]` syntax. Built-in documentation!

This is also more <em>maintainable</em> code since we can now capture other parts without messing up our existing match captures.

<figure>
  {% highlight ruby %}
      parsed_domain = "http://alex.func-i.com".match /(?<protocol>https*:\/\/)?(?<subdomain>.+)\.(?<parent_domain>.+\..+)/
  {% endhighlight %}
</figure>

### Why not?

Okay, so it's more expressive and more maintainable. I know what you're thinking: surely there's a good reason not to do this! How about performance?

<figure>
  {% highlight ruby %}
      n = 5000000
      Benchmark.bm(8) do |x|
        x.report('named:') do
          n.times { "alex.func-i.com".match(/(?<subdomain>.+)[\.|^](?<parent_domain>.+\..+)/)[:parent_domain] }
        end

        x.report('unnamed:') do
          n.times { "alex.func-i.com".match(/(.+)[\.|^](.+\..+)/)[2] }
        end
      end

                     user     system      total        real
      named:    13.930000   0.080000  14.010000 ( 14.017746)
      unnamed:  13.250000   0.090000  13.340000 ( 13.333811)
  {% endhighlight %}
</figure>

So there you have it: a slight difference in performance. But we're running these 5,000,000 times. On a more likely scale, the benefits of using named match captures far outweigh any performance concerns. Try it in your next project!

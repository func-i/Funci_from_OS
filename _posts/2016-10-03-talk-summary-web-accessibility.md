---
layout:     post
title:      Introduction to Web Accessibility 
author:     kristin
date:       2016-10-03
published:  true
social_image: blog_posts/accessible-staircase.png
description: This is a talk summary on the topic of introducing the importance and best practices for creating web accessible projects.
---

# Intro to the Importance of Web Accessibility | A Talk Summary

"The power of the Web is in its universality. Access by everyone regardless of disability is an essential aspect." - Tim Berners-Lee, W3C Director and inventor of the World Wide Web

A disability is a mental or physical condition that limits a persons senses, movements, or activities. An estimated 3.8 million Canadians report as having a disability. The limits of a disability vary from person to person, and one person may have any combination of conditions that affect their daily life. A person with a disability may face limitations and barriers when they use the web.

<!--more-->

A user may not identify with a disability but still benefit from accessible technology.  Any user may find themselves situationally or temporarily benefitting from an accessible product.

## What are the methods we use to make the web accessible?

These are just a few examples.

### Visual

* Blind users may use a screen reader that converts text into synthesized speech. Any meaningful images should have descriptive text in the alt tags. Any purely decorative or complementary images should have the alt tags left blank, so screen readers will skip over them.

* Colour contrast between text and background should be strong enough for those with low vision or colourblindness.

* Colour alone should never convey meaning or intent. Additional cues should be added.

![Pie chart depicting the likely percentage of all users who may need accessible technology. None 56.2 million, Not likely 43%. Mild 51.6 million, Likely 40%. Severe 22.6 million, Very likely, 17%.]({% asset_path blog_posts/Pie-chart-depicting-percentage-need-accessible-technology.png %})

### Auditory

* Multimedia content should be supplemented  with transcriptions or captions.

![Screenshot of a Facebook video with captions added]({% asset_path blog_posts/video-captions.png %})

### Motor

* There are a wide variety of assistive technologies available for users with limited motor skills, such as voice recognition or eye tracking software.

* Most of these technologies work through the keyboard or emulate the functionality of one. To ensure that a web site is accessible for people with motor disabilities, it should be navigable using the keyboard only.

### Cognitive

This is a very broad category but there are still things developers, designers, and content creators can do to make the web more accessible for someone with a cognitive disability.

* Flashy pop ups and blinking elements are distracting to those who have trouble focusing.

* Content should be as clear and easy to comprehend as possible.

* Descriptive error messages can prevent someone with problem-solving difficulties from getting frustrated and leaving the site altogether. Take a look at the [Best Buy 404 page](http://www.bestbuy.com/404) - it clearly explains what may have gone wrong, and provides a list of solutions.

### Seizure

* Strobing or flashing lights can trigger seizures in some people and should be avoided. If you MUST use this effect, be like Kanye West and warn people.

![Screenshot of a YouTube video warning that it has the potential to cause seizures in people with photosensitive epilepsy]({% asset_path blog_posts/seizure-warning.png %})

## Why do we need an accessible web?

We pride ourselves on having a Web that is open and free to all.  When a web site is inaccessible to someone with a disability, they are excluded from something that is supposed to be for everyone.

As more and more of our important daily activities move to the web, users may find themselves unable to do simple things such as pay a bill, or apply for a job.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/WellsFargo">@WellsFargo</a> please fix your website. It has broken screen reader accessibility. THis is urgent. Site so inaccessible I can&#39;t even email you.</p>&mdash; Travis Roth (@travisroth) <a href="https://twitter.com/travisroth/status/774236980758532097">September 9, 2016</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Hey, <a href="https://twitter.com/united">@United</a>. Your employee res site for booking pass riders is inaccessible to screen reader users. Pleas fix this! <a href="https://twitter.com/hashtag/a11y?src=hash">#a11y</a></p>&mdash; Lindsay Yazzolino (@GrammarGlamor) <a href="https://twitter.com/GrammarGlamor/status/598982027291922433">May 14, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Now that both new <a href="https://twitter.com/SAS">@sas</a> beta and new <a href="https://twitter.com/Fly_Norwegian">@fly_norwegian</a> site are completely inaccessible it seems I have to keep flying <a href="https://twitter.com/britishairways">@britishairways</a> <a href="https://twitter.com/hashtag/a11y?src=hash">#a11y</a></p>&mdash; SteinErik Skotkjerra (@Skotkjerra) <a href="https://twitter.com/Skotkjerra/status/748422016173215744">June 30, 2016</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Sleepio">@Sleepio</a> Hi! Is there any way to include subtitles/closed captions? I&#39;m hard of hearing and couldn&#39;t understand the Prof :)</p>&mdash; R2-D2 (@NotKdamoney) <a href="https://twitter.com/NotKdamoney/status/578063560493821954">March 18, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/digitalocean">@digitalocean</a> I really want to use your service, but sadly your site is still completely inaccessible to people using keyboard navigation</p>&mdash; David Sexton (@daiverd) <a href="https://twitter.com/daiverd/status/753247132266606592">July 13, 2016</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Starbucks">@starbucks</a> Hi, I&#39;d love to be able to use your new mobile order feature, but it is inaccessible to blind iOS users.</p>&mdash; Lindsay Yazzolino (@GrammarGlamor) <a href="https://twitter.com/GrammarGlamor/status/649238913010302976">September 30, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Ensuring the accessibility of your product is simply the right, moral, compassionate thing to do. If you’re still not convinced though, consider this - almost 20% of users probably need to use some form of assistive technology. Is this a market you’re willing to alienate?

Accessible web site = loyal customers. If a user can easily use your product, they are more likely to come back to it time and time again and speak highly of it to others.

### Accessibility Laws

Many jurisdictions have introduced web accessibility legislation. Most of them follow some form of the [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/intro/wcag)  published by the World Wide Web Consortium (W3C).

There are 3 levels, A, AA, AAA, corresponding the the level of accessibility.

The [Ontarians with Disabilities Act](http://www.aoda.ca/) has set several deadlines for government and public sector websites to comply with WCAG. By January 2020, all of these sites must comply with WCAG Level AA or higher.

Even though accessibility is required by law, legal action is still rare.  In March 2016, a California court ruled that a retail website violated the Americans with Disabilities Act. So far, this is the only ruling of its kind.

### How do we make the web more accessible?

These are 5 easy accessibility wins:

1. Pay attention to alt text with images - make sure it’s left blank on images that are purely decorative and descriptive of any meaningful images.
2. Test your site using a keyboard.
3. Design colour schemes for accessibility.
4. Take care to properly label forms.
5. Write semantic HTML.

When we learn how to make websites, accessibility is often seen as an extra, or an afterthought.

Accessibility should be built into to the way we learn.

We should teach each other and hold each other accountable for baking accessibility in to the products we create.

VoxMedia's [Accessibility Checklist](http://accessibility.voxmedia.com/) holds everyone, from Project Managers to Editorial to QA, responsibile for accessibilty.

Web accessibility shouldn’t be treated like a ramp propped up on stairs…

![An image of a flimsy portable ramp propped up on a staircase]({% asset_path blog_posts/accessibility-ramp.png %}) 

… but a creation from the ground up that takes into account people of all abilities. 

![An image of a staircase with ramps built in.]({% asset_path blog_posts/accessible-staircase.png %})

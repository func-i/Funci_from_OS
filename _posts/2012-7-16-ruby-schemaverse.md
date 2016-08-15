---
layout:     post
title:      Rubies on Elephants in Space
subtitle:   A ruby wrapper to play Schemaverse
author:     jon
date:       2012-9-16 16:21:22
published:  true
description: Schemaverse is a MMO written entirely in Postgres and promotes my favourite play style when it comes to gaming; botting. As a programmer and a gamer (who hates to lose), I can't resist combining my two passions.
---

[Schemaverse](http://schemaverse.com) is a MMO written entirely in Postgres and promotes my favourite play style when it comes to gaming; botting. It's cheating, I'm a horrible person and I should be banned from every game I play (I mean that). As a programmer and a gamer (who hates to lose), I can't resist combining my two passions. I was reading a [HackerNews article](http://news.ycombinator.com/item?id=3969108) about Schemaverse and it peaked my interest. A game meant to be played by programmers in SQL where scripting is the norm. My bot vs yours? Do we play for keeps?

As a rubyist I wanted to play the game but writing scripts in PL/pgSQL wasn't exactly my first choice and it might not be yours either. So after contacting [Abstrct](https://github.com/Abstrct) the creator of Schemaverse, I set out to write a ruby wrapper to play the game. Together we created a public github project which players can fork and deploy for free to [Heroku](http://heroku.com).

<!--more-->

### Getting Started

In order to play you must register at [Schemaverse.com](https://schemaverse.com/). You do not need to give an email address, just a username and password.

[Fork](https://help.github.com/articles/fork-a-repo) [ruby-schemaverse](https://github.com/func-i/ruby-schemaverse) and begin modifying the strategy inside [schemaverse.rb](https://github.com/func-i/ruby-schemaverse/blob/master/lib/schemaverse.rb).

The current code contains basic game play which will do the following:
* Build miners on your conquered planets to gather fuel
* Upgrade the mining abilities of your ships
* Build new ships to travel to other planets and conquer them
* Attack any ships that enters your range

### Heroku

Once you have your strategy ready to do battle, you can deploy it to Heroku. If you do not have an account, visit [Heroku.com](http://www.heroku.com/) and sign up. It's free and your sign up comes with one free worker.

{% highlight bash %}

# in your project folder
$> heroku create
$> heroku config:add SCHEMAVERSE_USERNAME=YOUR_USERNAME
$> heroku config:add DATABASE_URL=postgres://YOUR_USERNAME:YOUR_PASSWORD@db.schemaverse.com/schemaverse
$> git push heroku master
$> heroku ps:scale worker=1

{% endhighlight %}

### It's on!

I will be perfecting my script on an ongoing basis. Feel free to pit your gaming and ruby expertise against mine!

### Additional Documentation

* [Schemaverse tutorial](https://schemaverse.com/tutorial/tutorial.php)

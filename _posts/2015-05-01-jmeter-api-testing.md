---
layout:     post
title:      Automated JSON API stress testing with JMeter Part 1
subtitle:   Stress test your APIs with millions of requests
author:     jon
date:       2015-05-01
---

Imagine you have created a JSON API that allows users to take tests or quizzes and you want to stress
test it to discover it's load capability.

JMeter is the "go to" tool for stress testing, and it should be.  It is extremely powerful, dynamic and scalable.  (insert reference to ec2-jmeter here)

<!--more-->

### What will I get from this guide?

This guide will show you how to:

* use Jmeter to send requests to your API
* use javascript to parse responses from the API
* set variables to be used in other requests
* make additional calls to your API based on previous calls

### Our example

Consider the following API:

<figure>
  <figcaption>GET /test</figcaption>
  <br />

  {% highlight javascript %}
  {
    "test": {
      "testee_id":  "ABC123",
      "question": {
        "id": 1,
        "title":  "What is your name?"
      }
    }
  }
  {% endhighlight %}
</figure>

Gets the first question in a test and returns a *testee_id* that will be sent as a header in future requests.
The system will use this header to identify the Testee.  It will also return the first question in the test.

<figure>
  <figcaption>POST /answer</figcaption>
  <br />

  post params:

  {% highlight javascript %}
  {
    "answer": {
      "question_id": "1",
      "value": "Sailias"
    }
  }
  {% endhighlight %}

  response:

  {% highlight javascript %}
  {
    "question": {
      "id": 2,
      "title": "How old are you?"
    }
  }
  {% endhighlight %}

  if our test is complete:
  <br />
  response:

  {% highlight javascript %}
  {
    "complete": true
  }
  {% endhighlight %}
</figure>

The endpoint for answering a question in the test.  The testee_id is required for this endpoint.
The response is the next question we are to answer.

<figure>
  <figcaption>GET /result</figcaption>
  <br />

  {% highlight javascript %}
  {
    "result": {
      "points_scored": 10,
      "points_available": 10
    }
  }
  {% endhighlight %}
</figure>

The endpoint that gives us our final test results.  When POSTing an answer doesn't give us another question, we have finished the test and can retreive our result.
  

### Getting started with JMeter

![Fig1]({% asset_path blog_posts/jmeter/fig1.png %})

* Add a "User Defined Variables" config element
* Add a new variable:
  * ![Fig1]({% asset_path blog_posts/jmeter/fig2.png %})
  * (this makes it easier to switch it to a live server without changing all your samplers)

* Add a Config Element/HTTP Header Manager
  * Content-Type -> application/json

* Add a sampler/HTTP Request
  * Server Name or IP -> ${site_url}
  * Method -> GET
  * path -> /test
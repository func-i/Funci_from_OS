---
layout:     post
title:      Automated JSON API stress testing with JMeter Part 1
subtitle:   Stress test your APIs with millions of requests
author:     jon
date:       2015-05-01
---

Imagine you have created a JSON API that allows users to take tests or quizzes and you want to stress
test it to discover it's load capability.

JMeter is the "go to" tool for stress testing, and it should be.  It is extremely powerful, dynamic and scalable.

<!--more-->

### What will I get from this guide?

This guide will show you how to:

* use JMeter to send requests to your API
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
        "title":  "What is 1 + 1?"
        "choices": [
          { "id": 1, "value": 1 }
          { "id": 2, "value": 2 }
          { "id": 3, "value": 3 }
          { "id": 4, "value": 4 }
        ]
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
      "question_id": 1,
      "choice_id": 1
    }
  }
  {% endhighlight %}

  response:

  {% highlight javascript %}
  {
    "question": {
      "id": 2,
      "title": "What is 1 x 1?"
      "choices": [
        { "id": 5, "value": 1 }
        { "id": 6, "value": 2 }
        { "id": 7, "value": 3 }
        { "id": 8, "value": 4 }
      ]
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
      "questions_available": 10,
      "questions_answered": 10,
      "questions_correct": 5
    }
  }
  {% endhighlight %}
</figure>

The endpoint that gives us our final test results.  When POSTing an answer doesn't give us another question, we have finished the test and can retreive our result.
  

### Getting started with JMeter

* Add a "User Defined Variables" config element:
  * ![Fig1]({% asset_path blog_posts/jmeter/fig1.png %})
* Add a new variable:
  * ![Fig1]({% asset_path blog_posts/jmeter/fig2.png %})
      * *this makes it easier to switch it to a live server without changing all your samplers*

* Add a Config Element/HTTP Header Manager:
  * ![Fig1]({% asset_path blog_posts/jmeter/fig3.png %})

* Add two values:
  * ![Fig1]({% asset_path blog_posts/jmeter/fig4.png %})
  * *TESTEE-ID will be set after the first call.  It is how the server will know who is answering questions.*

* Add a sampler/HTTP Request:
  * ![Fig1]({% asset_path blog_posts/jmeter/fig5.png %})


We now have a sample API, and a basic setup for a JMeter project which will hit our */test* endpoint to start
taking the test.

The next steps will be to have the JMeter automatically answer the questions in the test 1 by 1
and then call the results page when complete.

We will do this by using a **BSF PostProcessor** with a script written in JavaScript.

This is covered in [Part 2]({% post_url 2015-07-28-jmeter-api-testing-part2 %})

Happy Coding!

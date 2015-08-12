---
layout:     post
title:      Automated JSON API stress testing with JMeter Part 2
subtitle:   Stress test your APIs with millions of requests
author:     jon
date:       2015-07-28
published:  true
---

If you are just finding this post, refer to [Part 1](post_url 2015-05-01-jmeter-api-testing-part1 %}) for the setup.
It deals with some of the basic API functionality and a basic JMeter setup.

Now we will get into the advanced JMeter setup that will allow you to traverse your API during your stress test.

<!--more-->

This approach is great for stress testing every endpoint in your application like a real user would and it's also great for 
building up data in your database to test your API as your dataset grows.

Ever had your database crash after 750K entries due to a missing index?  Yeah, me neither.

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

Our next request is:

<figure>
  <figcaption>POST /answer</figcaption>
  <br />

  {% highlight javascript %}
  {
    "answer": {
      "question_id": 1,
      "choice_id": 1
    }
  }
  {% endhighlight %}
</figure>

To set up the POST data for a new request we use a *BSF Post Processor*

* Right click the HTTP Request
* Add a BSF Post Processor
* Set the language to javascript (I'm writing this in JS, I'm a web developer)
* Write your script
* Profit

<figure>
  <figcaption>Script:</figcaption>
  <br />

  {% highlight javascript %}
  
  eval('var JSonResponse = ' + prev.getResponseDataAsString());

  var answerData = {
    answer: {
      question_id: JSonResponse.test.question.id,
      choice_id: JSonResonse.test.question.choices[0]
    }
  } 

  vars.put("answerData", JSON.stringify(answerData));

  {% endhighlight %}
</figure>

Well that was uneventful.  What was that for?  
It was only to set the answerData variable for future use.

How do we use it?

### Continue with a while loop

* Add a *While Controller*
  * Set the condition to: ```${__javaScript('${answerData}' !== '')}```
* Add a HTTP Request to the While Controller
  * ![Fig1]({% asset_path blog_posts/jmeter/fig6.png %})
* Add a BSF Post Processor to this new HTTP Request

<figure>
  <figcaption>Script:</figcaption>
  <br />

  {% highlight javascript %}
  
  eval('var JSonResponse = ' + prev.getResponseDataAsString());

  if(JSonResponse.complete)
    vars.put("answerData", "");    
  else {
    var answerData = {
      answer: {
        question_id: JSonResponse.test.question.id,
        choice_id: JSonResonse.test.question.choices[0]
      }
    } 

    vars.put("answerData", JSON.stringify(answerData));
  }

  {% endhighlight %}
</figure>

* Add a new HTTP Request to /result

Remember our original workflow from [Part 1](post_url 2015-05-01-jmeter-api-testing-part1 %}).

* GET /test 
  * done by our first HTTP Request
* POST an answer 
  * a BSF Post Processor
  * a new HTTP Request
* Returns the next question in the JSON Response
* Keep answering the questions until complete 
  * a While Controller
  * HTTP Request posting answerData
  * another BSF Post Processor
* GET /result (last HTTP Request)

And you're done.











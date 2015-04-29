---
layout:     post
title:      Tips for More Painless Protractor Tests
subtitle:   Lessons from my first AngularJS app
author:     ting
date:       2015-04-22 
---

Protractor is for writing end-to-end tests. It starts your web app in a browser and runs your tests against the app. The tests are written to simulate user actions in the browser, such as clicking a button, and to test DOM conditions as a result of those actions. In general, that means your test code runs against/can access the *browser*, not the internals of the app itself.

As I worked through testing with Protractor for the first time, I learned a few things that I hope can help you as you get started.

<!--more-->

### Nest describes with Jasmine

In front-end testing, the developer often has to test multiple interaction sequences from one start point. For example, suppose on page Pa there are buttons a1 and a2; clicking a1 goes to page Pb, and clicking a2 goes to page Pc. On page Pb there are buttons b1 and b2; clicking b1 goes to page Pd, b2 goes to page Pe.

What is the best way to organize the test scripts? The way I prefer is to use nested describes (Jasmine and CoffeeScript syntax):

<figure>
  {% highlight coffeescript %}

      describe 'Page Pa', ->   
        beforeEach ->       
          login()
          goToPagePa()

        afterEach ->
          logout()

        it 'starts on page Pa', ->
          expect(browser.getLocationAbsUrl()).toBe BASE_URL + '/Pa'

        describe 'Clicking button a1', ->
          beforeEach ->
            element(By.css '.button-a1').click()

          it 'goes to page Pb', ->
            expect(browser.getLocationAbsUrl()).toBe BASE_URL + '/Pb'

          describe 'Clicking button b1', ->
            .....

          describe 'Clicking button b2', ->
            .....

        describe 'Clicking button a2', ->
          .....

  {% endhighlight %}
</figure>

### Wait for DOM changes

Protractor uses the WebDriverJS API, which is asynchronous. All functions return promises, and WebDriverJS keeps a queue of pending promises (called the control flow) to execute them in sequence. On top of this, Protractor automatically applies browser.waitForAngular() before every action to wait for all Angular $http and $timeout calls to finish. This allows developers to write the test scripts without much dread "callback hell," for the most part.

My app, however, is largely socket-based. This means we have socket events firing off handlers that change the display of a directive embedded on a page. Neither the WebDriverJS control flow nor waitForAngular() could make Protractor test for the expected DOM condition *after* the socket action sequence finishes. 

One way to handle this problem is by using **browser.driver.wait()**

<figure>
  {% highlight coffeescript %}

      browser.driver.wait ->
        element(By.css '.my-directive').getText().then (theText) ->
          theText is 'Some Socket Event'
      , 5000

  {% endhighlight %}
</figure>

The code above would keep checking the directive with class my-directive until its text changes to 'Some Socket Event', or it times out after 5 seconds. If it times out, the test fails.

### Organize your mock modules

For my socket tests, I need to invoke specific socket-event handlers without mocking the events. That means my tests need to reach into the app and call those functions. How do we accomplish that in Protractor which only uses the browser? The setup relies on two Protractor functions: browser.addMockModule and browser.executeScript. (For some background, check out my coworker Jon's [previous post](http://www.functionalimperative.com/2015/04/22/protractor-socket-mocks.html).)

As a general rule, I prefer to keep application code and test code in two separate places. The mock modules added by addMockModule are run *as* part of the app *from* the tests, as is the code inside executeScript blocks (in effect). I chose to place the mock modules and executeScript blocks in the /test folder, since they were written specifically for testing. Consequently, within my /test folder, some files contain test code, which accesses the browser and deals with DOM, while others contain app code running in the browser and playing with application internals. Some files even contain both, with app code inside executeScript blocks and test code elsewhere.

It tooke me a while to organize the files and remember where I was. Am I writing test code or app code now? Should this function be in test code or (mock) app code? One annoying bit I kept messing up at first was mocking data: since different tests needed different mock data, it made better sense to me to put the factory functions in test code. But I kept forgetting myself, and kept getting errors when I called the factory functions from the mock app modules, instead of calling those functions from the tests and passing the generated data to the app modules.

But all things considered, this setup makes the most sense and will help you maintain your sanity as you work with Protractor.

Happy testing!
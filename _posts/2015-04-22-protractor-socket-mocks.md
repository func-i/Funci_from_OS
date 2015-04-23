---
layout:     post
title:      Protractor Socket Mocks
subtitle:   Mock your socket functionality in Protractor
author:     jon
date:       2015-04-22 
---

### Problem

While testing I wanted to mock two types of external calls, API calls a Socket connection.
Mocking http calls is fairly straightforward and well documented using [$httpBackEnd](https://docs.angularjs.org/api/ngMock/service/$httpBackend).
There is a [socket mock](https://github.com/nullivex/angular-socket.io-mock) for [angular-socket.io](https://github.com/btford/angular-socket-io) which we were not using.
So we had to do it another way.

### Stack

* AngularJS ~1.3
* sio-client ~1.3.6

<!--more-->

### Setup

Lets make a simple example where a user logs in and is brought to a chat channel for tech support.

I write in Coffeescript, deal with it!  
To see how we boilerplate our angular coffee apps visit [angular-coffee-boilerplate](https://github.com/func-i/angular-coffee-boilerplate)


Consider the following socket service:  

<figure>
  <figcaption>socket_service.coffee</figcaption>
  <br />

  {% highlight coffeescript %}

      @serviceModule.service 'socketService', ($injector, userService) ->

        init: ->        

          # connect to the socket
          @socket = io 'https://some-socket.server.com:9999'

          # Subscribe to the user's chat room
          @subscribe()

          # The server will send back a subscribed event
          @socket.on 'subscribed', (data) -> 

            # All events will be handled by "Handlers"
            $injector.get('SubscribeHandler').process(data)

        subscribe: ->

          # After logging in, 
          # the user should have a channel they can subscribe to
          socketId = userService.socketChannelId

          # Subscribe to the channel in the socket
          @socket.emit 'subscribe',
            socket_id: socketId

  {% endhighlight %}
</figure>

<figure>
  <figcaption>./handlers/subscribed_handler.coffee</figcaption>
  <br />

  {% highlight coffeescript %}

    @serviceModule.service 'SubscribeHandler', ($state) -> 

      process: (data) ->  

        # We are logged in and have subscribed
        # to our chat channel.  

        # View the chat
        $state.go 'chat'

  {% endhighlight %}
</figure>

### Tests

The functionality above will connect to a socket, subscribe to a channel and redirect to a route that will view that chat channel.  Let's write a test for that.

{% highlight coffeescript %}
  # Load our mocked socketService 
  # described below
  socketServiceModule = require("./mock/socket_service_mock.js")   

  describe 'Subscribe Event', ->

    it 'should bring me to my chat channel when logged in', ->
      
      # Overwrite the socketService module with a mocked version
      browser.addMockModule('myApp.services', socketServiceModule.socketService)        

      # Login to the app 
      login()

      # Expect the app to login and redirect us to our chat channel
      expect(browser.getLocationAbsUrl()).toBe "/chat"


{% endhighlight %}

Assume that after logging into my API I call:

{% highlight coffeescript %}
  socketService.init()
{% endhighlight %}

### Mocks

<figure>
  <figcaption>protractor.conf.coffee</figcaption>
  <br />
  {% highlight coffeescript %}
    onPrepare: ->

      # Declare a global login function
      # that will log me in and I can call
      # from my tests 
      global.login = ->
        # Go to the login URL
        browser.get(BASE_URL + '#/login')

        # Fill out the form and click the button
        element(by.css('input[type="text"]')).sendKeys('test')
        element(by.css('input[type="password"]')).sendKeys('test')
        element(by.css('button')).click()

  {% endhighlight %}
</figure>

<figure>
  <figcaption>./mock/socket_service_mock.coffee</figcaption>
  <br />
  {% highlight coffeescript %}
    module.exports.socketServiceEmpty = ->
      # Important, DO NOT include ", []" in the line below.
      # That will clear your entire services module!
      # We only want to overwrite our socketService
      socketModule = angular.module("myApp.services")

      # Redeclare the socketService
      socketModule.service 'socketService', ($injector) ->
        init: ->
          # Instead of doing all the connection stuff
          # just call our SubscribeHandler
          @broadcast("SubscribeHandler", {})

        broadcast: (handler, data) ->
          $injector.get(handler).process(data)

  {% endhighlight %}
</figure>

Our test should now pass!  We have not mocked the socket library itself but we have mocked the socketService
that handles all our socket functionality.

We have made our code modular enough that replacing the socket functionality is extremely easy.

### Testing events in the socket

We need a way to trigger events coming into the socket and test their outcome in the DOM.
We have already decided that all events will have a Handler, we also have a broadcast event in our socketMock.

We can use this setup to trigger socket events and test their outcome.

Let's add the following line to our init function in:

<figure>
  <figcaption>socket_service.coffee</figcaption>
  <br />

  {% highlight coffeescript %}
      
    # The chat will receive messages
    @socket.on 'messageReceived', (data) -> 
      $injector.get('MessageHandler').process(data) 

  {% endhighlight %}
</figure>

<figure>
  <figcaption>./handlers/message_handler.coffee</figcaption>
  <br />

  {% highlight coffeescript %}

    @serviceModule.service 'MessageHandler', (messageService) -> 

      process: (data) ->  

        # add the message to the message service
        # We can assume that this service takes the message
        # and adds it to an array
        messageService.messageReceived(data)

  {% endhighlight %}
</figure>

### Test 2
{% highlight coffeescript %}
  # Load our mocked socketService 
  socketServiceModule = require("./mock/socket_service_mock.js")   

  describe 'Message Received Event', ->

    it 'should add a new message to the chat', ->
      
      # Overwrite the socketService module with a mocked version
      browser.addMockModule('myApp.services', socketServiceModule.socketService)        

      # Login to the app 
      login()

      chatData = 
        message: "This is a new message"

      # Trigger message received
      # Call a custom method that broadcasts in our socket
      # defined below
      broadcastToSocket("MessageHandler", chatData).then ->
        
        # Add your expect here to check the message length
        expect(element(By.css('.message').length)).toBe(1)


{% endhighlight %}

Add to onPrepare in:

<figure>
  <figcaption>protractor.conf.coffee</figcaption>
  <br />
  {% highlight coffeescript %}
    
    global.broadcastToSocket = (handler, data) ->
      # Execute a script in the protractor browser
      # Pass in handler and data as arguments
      browser.executeScript( ->
        angularElement = angular.element(document.body)

        # Load the current socketService
        socketService = angularElement.injector().get("socketService")

        # Call the broadcast method which calls our handler
        socketService.broadcast(arguments[0], arguments[1])
      , handler, data)

  {% endhighlight %}
</figure>

And there you have it.  A socket setup that works in development and a socket mock that works in tests!
We can now trigger any socket events we want and their affects on the DOM.

If you want to test your socket functions in more detail, (ie, making sure it emits back to the socket),
then you can always write unit tests.








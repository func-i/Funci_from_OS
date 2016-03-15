---
layout:     post
title:      A Namespacing Function for Client-Side Javascripts
author:     noam
date:       2014-5-10 16:21:22
published:  true
description: Here's a simple method you can use to namespace your client-side scripts. There's many ways to do this, probably better ones. The point is to do it at all.
---

Here's a simple method you can use to namespace your client-side scripts.
There's many ways to do this, probably better ones. The point is to do it at
all.

Suppose we've two scripts, `foo.js` and `bar.js`.

### foo.js:

{% highlight javascript %}

    function foo() { console.log("Foo!") };

{% endhighlight %}

### bar.js:

{% highlight javascript %}

    function bar() { console.log("Bar!") };

{% endhighlight %}

<!--more-->

This is what most javascripts look like. This is why puppies die, the
bad guys always win, and we can never have anything nice.

So, before we even worry about namespacing, let's start with the
essentials: always wrap it.
We don't want to muddy up our global namespace. Ever. Except when we do.

> **First rule of Javascript:** Always wrap everything.

Just like they taught you
in school. (Unless you went to one of those schools down south where they
teach that the only
sure-fire way to prevent name collisions is to never write code in the first
place -- yet here you are, so how'd that work out?)

### foo.js

{% highlight javascript %}

    // semicolon to avoid concatenation errors
    ;(function() {
        function foo() { console.log("Foo!") };
    })(); // <-- function calls itself.

    // Nice and clean global context.

{% endhighlight %}

Ok, now we're ready for our namespacing function. This function creates a
function that initiates a namespace:

### appendToNamespace()

{% highlight javascript %}

     function appendToNamespace(namespace, elementName, elementValue) {
        // If namespace has already been initialized, simply append new
        // element.
        if (typeof window[namespace] === "object") {
          window[namespace][elementName] = elementValue;
        }

        // If namespace has not been initialized, but an initialization function
        // exists, copy its old value so that new initialization function may
        // call it.
        var oldNamespaceFunction = function(){};
        if (typeof window[namespace] == "function") {
          oldNamespaceFunction = window[namespace];
        }

        // Create function that intializes namespace.
        if (typeof window[namespace] !== "object") {
          window[namespace] = function() {
            window[namespace] = {};
            // Call old initialization function too.
            oldNamespaceFunction();
            window[namespace][elementName] = elementValue;
          }
        }
      }

{% endhighlight %}

Now foo.js becomes:

### foo.js

{% highlight javascript %}

    ;(function() {
        appendToNamespace("YourNameSpace", "foo", foo)
        function foo() { console.log("Foo!") };
    })();

{% endhighlight %}

Ditto for bar.js.

### index.html

{% highlight html %}

    <html>
        <head>
            <script src="foo.js"></script>
            <script src="bar.js"></script>
            <script>
                // initialize YourNameSpace
                YourNameSpace();
            </script>
        </head>
        <body>
            <script>
                // Now your scripts are available under the YourNameSpace
                // object.
                YourNamespace.foo(); // -> "Foo!"
                YourNamespace.bar(); // -> "Bar!"
            </script>
        </body>
    </html>

{% endhighlight %}

Note that it doesn't matter in what order initialization happens:

### index.html

{% highlight html %}

    <html>
        <head>
            <script src="foo.js"></script>
            <script>
                // initialize YourNameSpace beofre second script is loaded.
                YourNameSpace();
            </script>
            <script src="bar.js"></script>
        </head>
        <body>
            <script>
                YourNamespace.foo(); // -> "Foo!"
                YourNamespace.bar(); // -> "Bar!"
            </script>
        </body>
    </html>

{% endhighlight %}

Of course, it's possible to do this in such a way that initialization is not
necessary at all. The reason I choose to it this way is because explicitly
requiring the script to initialize the namespace makes it easier to write
scripts that play nice across platforms (say, when using libraries
like browserify.

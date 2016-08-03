# Introduction to API Security with OAUTH 2.0

I recently had a joyous time reading through the RFC6749 Standard Specification for OAuth 2.0. This in combination with RFC6819, OAuth 2.0 Threat Model and Security Considerations and other online resources provide you with a thorough technical understanding of the underlying mechanisms of OAuth 2.0. I recently gave a talk about this topic, a synopsis of which follows below.

<iframe src="http://www.slideshare.net/func_i/slideshelf" width="615px" height="470px" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:none;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>

In this exposition, I assume that the reader is already acquainted with a basic implementation of OAuth 2.0, understands the difference between authorization and authentication, the password anti pattern, consent form and has a general understanding of the Authorization Code Grant Flow. 

If not, then checkout: 
this [Oauth Workflow Guide](https://hueniverse.com/oauth/guide/workflow/) and an
[Introduction to Oauth](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)

What follows is a step by step introspection of the various HTTP communications that happen between the relevant actors involved, together with a few security considerations where applicable.

## Authorization Endpoint

At this stage, the client application makes a GET request to the Authorization Server:
```
GET /authorize?  
response_type=code&  
client_id=123456789&  
redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb&
scope=followers%20tweet_feed&  
state=aFodshfj(klMN 
HTTP/1.1 
Host: server.oauth_provider.com
```
In order to invoke the Authorization Code Grant Flow, the response_type is set to code. The param: `client_id` is obtained when having registered our client application with the Authorization Server and together with the `redirect_uri` param will ensure that the authorization code that eventually will be issued is confined to our client application.

The specification, RFC6749, states that the Authorization Server MUST ensure that the redirect_uri provided corresponds to the one that was registered accordingly. In no case should the Authorization Server allow the client application to be registered without a redirect uri as doing so could potentially be exploited under the Open Redirect Attack see: [OAuth 2.0 Redirection URI Validation](https://hueniverse.com/2011/06/21/oauth-2-0-redirection-uri-validation/). 

The scope param enumerates the level of access the client application would like to obtain from the resource owner, which the Authorization Server may fully or partially ignore according to its policies or the resource owner’s instructions. 

Lastly, the state param is an opaque value used by the client to maintain state in our stateless protocol of communication so as to thwart off cross-site request forgery attacks.


## Redirect Endpoint

The response to the above by the Authorization Server to the User Agent is a redirect as follows:
```
HTTP/1.1 302 Found  
Location:https://client.example.com/cb?  
code=SplxrhJY654090l&  
state=aFodshfj(klMN
```
The browser will extract the relevant redirect URI from the Location header, inject it in itself accordingly and thus redirect the user to the corresponding redirect endpoint to rendez-vous with the client application. At this endpoint, the client application should be solely concerned with extracting the authorization code from the URI and if a state has been provided, extract the same and verify if it is the same one as it issued in the initial GET request above.

The security considerations of sharing an authorization code as a param in a redirect response are several:

First and foremost, care must be taken that this particular endpoint does not include any third party scripts such as third-party analytics, social plugins, ad networks etc. as they may propagate this redirect uri together with your authorization code over the net and likewise expose it to the world to see.

This endpoint should only be concerned with extracting the credentials and forthwith redirect the user to a different endpoint altogether where the user may start interacting with the application. One potential security breach if this point is not honoured is that when a user were to for instance click on an external link mentioned at this endpoint, then the browser will automatically set the `Referer` header to the current location, which includes the authorization code and thus expose the same to the third party application the user has navigated to.

For this reason, the Authorization Server should submit the Authorization Code with a short expiration duration to mitigate any risks of leaks. If the authorization code is used more than once, then the Authorization Server must deny the request and should revoke all tokens previously issued based on that authorization code. This should eliminate the security risk of replaying authorization codes.

## Token Endpoint

The authorization code only serves as an intermediate step, soon to be traded in for the access token. After the client application has successfully and securely obtained the authorization code, it should forthwith exchange the same for an access token and thus the client application will reach out to the authorization server with a POST request like this:
```
POST /token HTTP/1.1  
Host:server.oauth_provider.com  
Content-Type:application/x-www-form-urlencoded  
Authorization:Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW

grant_type=authorization_code&  
code=SplxrhJY654090l&  
redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
```

The RFC6749 standard stipulates that a POST request be done as opposed to a GET request as generally speaking, GET Requests are less secure as they are likely to be logged in Web proxy logs, browser histories, and Web server logs (Dowd, Mark, John McDonald, and Justin Schuh. "Web Applications." The Art of Software Security Assessment: Identifying and Preventing Software Vulnerabilities. Indianapolis, IN: Addison-Wesley, 2006. 1033. Print.). An Apache Web Server for instance will provide out of the box logging of GET requests, whereas for POST requests extra configurations need to be made. See: [Logging Http POST in Apache?](http://serverfault.com/questions/51295/logging-http-post-in-apache).

RFC6749 further stipulates that the OAuth Server must support the HTTP Basic authentication scheme for clients that were issued a client secret. In our POST request, this is implemented in the Authorization Header that is set to the value: 

Basic czZCaGRSa3F0MzpnWDFmQmF0M2JWx

This string is a Base64 encoding https://en.wikipedia.org/wiki/Base64 that maps a client identifier together with the client secret of the format: `client_id:client_secret` to a string with characters limited to a subset of 64 ASCII characters that represent the common denominator of most encodings out there and are also printable. RFC2617 confesses that the ‘Basic’ authentication scheme is not a secure method of user authentication, nor that it does in any way protect the entity, which is transmitted in cleartext across the physical network used as the carrier. 

**The main reason for this encoding is that:**

1. The authorization header generally does not get logged by server logs.

2. Base64 helps to ensure that data remains intact without modification during transport.

Even though the standard specifies that the Authorization Header should be supported by the OAuth Server, some provider, such as Facebook, do not support it as the Authorization Header specification was a later addition to the standard and thus another, not recommended method, was already implemented, namely including the client_id and client_secret as params in the request body instead. 

Thereafter follows a space to separate the header from the request body. This request body is according to the Content-Type Header URL encoded. The first param, grant_type set to authorization_code is to communicate to the OAuth Server that we would like to engage in a trade of the Authorization Code in lieu of an Access Token. The code param is set to the Authorization Code that we received earlier together with a redirect uri which the OAuth Server is required to double check.

As stated previously, the Authorization Code we obtained in our first interaction is bound to client_id and the redirect_uri. When the Authorization Server receives this POST request, it will then first and foremost authenticate the client by means of the Authorization Header. Once Authenticated, it will then check to see if the Authorization Code submitted belongs to the current application with stated client_id for the stated redirect_uri.

At this point, a question may come to the reader’s mind that OAuth 2.0 as an Authorization Framework is only concerned with authorization. It does not concern itself with Authentication, thus how does authentication have a place in our OAuth paradigm? The answer is that OAuth 2.0 may not concern itself with User Authentication, as that is handled by another standard such as OpenID, but it does concern itself with the authentication of the client application as this component is one of the main pillars to ensure a secure delivery of the authorization grant to the client application. Over and above that, another advantage of client authentication is the ability to recover from a compromised client by disabling it. An extra security layer can even be introduced by periodic credential rotation. Lastly, it protects the client from substitution of the authorization code.

**If all went well, then the OAuth Server will reply as follows:**
```
HTTP/1.1 200 OK  
Content-Type:application/json;charset=UTF-8  
Cache-Control:no-store  
Pragma:no-cache
```
```
{  
  "access_token":"2YotnFZFEjr1zCsicMWpAA",  
  "token_type":"example",  
  "expires_in":3600,  
  "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",  
  “example_parameter":"example_value"  
}
```
As we can see, the response body contains our access token and in our case contains a refresh token as well, encoded in JSON format as the Content-Type header stipulates. The two remaining headers, Cache-Control and Pragma are required to be set as such per RFC6749 and both serve the same purpose, namely to communicate that the response should not be cached as per HTTP/1.1 and 1.0 respectively.

## Obtaining Resources

After having obtained the access token as detailed above, the client application can then use the same to obtain the required resources, and thus may reach out to the resource server as follows:

GET /resource/1 HTTP/1.1  
Host: example.com  
Authorization: Bearer 2YotnFZFEjr1zCsicMWpAA

The Authorization header in this case contains the access token, signifying that it is a bearer token as opposed to for instance a MAC Token. A bearer token follows the principle, finders keepers, losers weepers, the submission thereof being the final authority in the matter. This of course after a first round trip check with the OAuth Server to confirm the validity of the token as well as the scope thereof. All else equal, the resource server is obliged to comply and will accordingly share the requested resources.

A final note pertains to the Implicit Grant, which as you know pertains to front end web applications that run in the browser without a back end server that is able to securely store a client secret. When a client secret cannot be relied upon, the inclusion thereof falls naught and thus accordingly there is no utility for client authentication. The GET request that the client application will thus make to the OAuth server is more or less the same, with the exception of the response_type param to invoke the Implicit Grant instead:
```
GET /authorize?  
response_type=token&  
client_id=s6BhdRkqt3&  
state=xyz&  
redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1  
Host: server.example.com
```
Noteworthy to mention here is the response thereof, which shares the access token, *in primo loco*, in the following format:
```
HTTP/1.1 302 Found  
Location:http://example.com/cb#  
access_token=2YotnFZFEjr1zCsicMWpAA&  
state=xyz&  
token_type=example&  
expires_in=3600
```
The point of consideration is that the Location Header of the redirect response comes with a hash fragment as opposed to a question mark as we are used to seeing. This fragment is required per RFC6749, as a hash fragment is supposed to be only processed by the browser. Only the browser side client application in Javascript is able to have access to the params that follow. Any potential underlying web server/application server will not have access to them as they get cut out.

It goes without saying that without client authentication etc., this grant type flow is less secure and should only be resorted to in the case that:

-1 There is no backend server that can be resorted to to implement the Authorization Code Grant Flow instead.  
-2 It pertains to read only information, such as the Static Google Maps API.

At most what an attacker could achieve with intercepting your access token issued here is to consume your maximum allocated quota of requests to the API, which is minimized by the fact that at the time of registration, the usage is limited(or should be limited) to the specified redirect URI.

## Further Reading

https://hueniverse.com/2012/07/26/oauth-2-0-and-the-road-to-hell/comment-page-1/

http://softwaremaniacs.org/blog/2012/07/30/oauth-is-not-a-protocol/en/

https://hueniverse.com/2015/09/19/auth-to-see-the-wizard-or-i-wrote-an-oauth-replacement/

http://homakov.blogspot.ca/2012/08/saferweb-oauth2a-or-lets-just-fix-it.html

http://www.oauthsecurity.com/

https://hueniverse.com/2010/09/29/oauth-bearer-tokens-are-a-terrible-idea/ 

[OAuth 2.0 - Looking Back and Moving On” by Eran Hamme](https://vimeo.com/52882780)  

https://www.youtube.com/watch?v=aBBDW1wsfH0

https://www.youtube.com/watch?v=zAUzVjMhbqw


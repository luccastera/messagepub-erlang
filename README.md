This is a simple gen_server node to send messages on AIM, Google Chat, Email, SMS, or Twitter using messagepub.

It is very easy to use:

1) Sign up for an account at <a href="http://messagepub.com">messagepub.com</a>

2) Once you've signed up, get your API key by going to your <em>Account Settings</em> at messagepub.com.

3) Copy your API Key.

4) Compile messagepub.erl: 
  
  c(messagepub).

5) Start the gen_server with your API KEY: 

  messagepub:start_link("YOUR API KEY").
  
6) Send messages using the send method. It takes three arguments: the channel (aim, twitter, email, gchat, phone, sms), the address, and the message. See examples below:


  messagepub:send("email","joe@example.com", "hello joe").
  messagepub:send("twitter", "the_real_shaq", "hi shaq!").
  messagepub:send("gchat", "example@gmail.com", "Hello friend").
  messagepub:send("aim", "username", "Saying hi from erlang").
  messagepub:send("sms", "1234567890", "Hi my SMS friend").
  messagepub:send("phone", "1234567890", "Hello on the phone").

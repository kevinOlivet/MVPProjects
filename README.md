# MVPProjects
A collection of MVP projects

#MVPTest

This project uses the MVP architecture pattern.

There is a User model that is managed by UserPresenter.
There is a NetworkService that simulates a hitting an asynchronous call to a network.
NetworkService uses a completion handler to supply UserPresenter and eventually UserViewController with data.
UserPresenter is aware of the view through a protocol (delegate pattern).

This project has some very interesting tests.
* It uses one mock object to simulate the NetworkService response.  Very useful!

* It uses another mock object to simulate the UserViewController. Nice!

Although in a real project I wouldn't test like this -
There is also a full test of a URLSession asynchronous response using "expectation" 
and of the NetworkService response.

Just to be clear, I know to use mock objects as you can see in the first two tests.
I'm just testing possibilities.

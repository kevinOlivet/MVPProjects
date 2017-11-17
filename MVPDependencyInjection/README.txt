#MVPDependencyInjection

This project uses MVP architecture to display a small list of Minions (like from the movie).

Originally it used MVC but the logic has been moved from the ViewController to MinionPresenter. 
The Presenter is now communicates to the ViewController via a protocol.

It's most interesting because of the tests. 
It uses a MockMinionService to mock the response from a web server.
To do this it overrides the call to the network: func getTheMinions.
getTheMinions uses a completion handler to send the data to the ViewController from class MinionService.

It also has a MockViewController so the actual ViewController or storyboard aren't needed to run the tests.

It then uses the mocks to test if the getTheMinions function was called 
and if the result matches the viewController's dataSource.
It verifies that the functions where called and their result or error.

The original MVC style can be found in the UnitTests repository.
It is called: UnitTestsDependencyInjection
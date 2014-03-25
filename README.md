CodeSample
==========

iOS Code sample

This code sample is designed to showcase my ability to handle concurrent operations and build and manage a UITableView.

The meat of the project is broken into two parts:

1) The landing view
2) The Fibonacci table view and calculation

The landing view is worth noting because I took the time to create a framework that will allow me to extend the number of problems solved in the future simply by editing a configuration file (com.karpodinis.resources.LandingViewDataSource.plist).  I generalized the data handling and validation for my future self to aid in the rapid addition of problems and their solutions over time so I could focus on creating solutions to new problems instead of revisiting old ones.  Chief among those 'old ones' is managing a table view full of data.

You'll notice that the landing view cell itself is partially data aware.  For the Fibonacci sequence, the cell will display the highest index calculated as well as how fast it was calculated; in the future, if you happen to calculate a higher index or an equvalient index with a faster speed, the landing view cell will update itself with that information.  The interface for this has been defined for future cells to make use of.

The Fibonacci calculation itself is asynchronous, delivering data back to the table view's data source as it is calculated.  There is a table row animation, though that may not be visible until Fibonacci calculations become more processor intensive.  The actual calculation work was offloaded to a secondary thread to aid in table view scrolling; the aim was to create a processor-intensive operation that yielded to the user interface.  Chief amonng the concerns of a software developer should be interface responsiveness, communicating to the user what's going on as it's happening.  Responsiveness is a direct analog to usefulness in this regard.
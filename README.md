This project is a client for a battleship game server. It contains a smart client and a random shooter client. 
The smart client should always win over the random one.

There were a couple problems in the server based on how I am sending the parameters in the request. 
The parameters were not being interpreted correctly so some of the server code was changed.

The typhoeus gem needs to be installed to run the client.

To run:
ruby start_client.rb
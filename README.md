# github-downloads - a gem for managing your downloads, on Github

This is a simple gem that does exactly what it says on the tin: manages your Github project downloads.

    $ gem install github-downloads

It can be used to list the downloads for your project:

    $ github-downloads list -u lukeredpath -r simpleconfig
  
It can also be used to create a new download:

    $ github-downloads create -u lukeredpath -r simpleconfig -f ~/myproject/somefile.zip -d "This is an important file"
  
### Github::Client, a generic Github API client

The gem is built on top of [version 3 of the Github API](http://developer.github.com/v3/); included in the source is a class, Github::Client, a simple wrapper around the Github API that uses RestClient and simplifies communication with the Github API. 

It provides a simple interface to the Github REST API. It handles errors appropriately and returns parsed response data as well as additional metadata such as API rate limits. 

It doesn't aim to be a full-blown Github API library (completely with a local domain model) but a very thin utility ckass that can be used to write other simple scripts and gems, like this one. Feel free to use this in your own project if you are working with the Github API.

### License

This code is provided under the terms of the MIT license.

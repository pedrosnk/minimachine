Mini Machine
============

This is a gem to short any kind of text into an id with the caracters to [0-9 a-z A-Z]
and store the key\value into a redis instance. Used mainly to short url

Version
-------

first release

    0.0.1
    
Instalation
-----------

    gem install minimachine
    
Usage
-----

First set a Redis server up and running, then connect to that server using the correct host and port

```ruby
mini = MiniMachine::MiniMe.new(:host => '127.0.0.1', :port => 6379)
```
    
store some url

```ruby
url_key = mini.insert_url('http://google.com')
```

recover the url from a given key

```ruby
my_url = mini.recover_url('1')
```
Install
=======
    sudo gem install gem-dependent

Usage
=====
    gem dependent my_gem

Output
======

    $ gem dependent my_gem
    other_gem (1.2.1)
    even_more (0.0.1)

TODO
=====
 - tests should run against a fixture/fakeweb
 - support `--local` / `--remote URL`
 - include reverse dependencies (a > b > c --> a = [b,c])

Author
======
[Michael Grosser](http://grosser.it)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...

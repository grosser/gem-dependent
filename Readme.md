Install
=======
    sudo gem install gem-dependent

Usage
=====
    gem dependent my_gem

    --source URL                 Query this source (e.g. http://rubygems.org)
    --no-progress                Do not show progress
    --fetch-limit N              Fetch specs for max N gems (for fast debugging)

Output
======

    $ gem dependent my_gem --source http://rubygems.org
    other_gem >= 1.2.1
    even_more = 0.0.1

    $ gem dependent XXX --source http://rubygems.org --no-progress | wc -l

    # Fun-facts from 2010-11-03
    bundler: 263
    activesupport: 983
    activerecord: 566

    hoe: 1454
    jeweler: 234
    echoe: 85

    nokogiri: 516
    hpricot: 297

TODO
=====
 - include reverse dependencies (a > b > c --> a = [b,c])
 - add tests for cli interface
 - add `--type development` support

Author
======
[Michael Grosser](http://grosser.it)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...

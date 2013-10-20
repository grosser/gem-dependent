Install
=======
    sudo gem install gem-dependent

Usage
=====
The first run can take looooong, but after the caches are filled, its pretty fast. Checking all versions will take significantly longer.

    gem dependent my_gem

    --source URL                 Query this source (e.g. http://rubygems.org)
    --no-progress                Do not show progress
    --fetch-limit N              Fetch specs for max N gems (for fast debugging)
    --parallel N                 Make N requests in parallel (default 15)
    --all-versions               Check against all versions of gems
    --type                       Only look for dependents matching the listed type(s) (default is runtime and development)


Output
======

    gem dependent my_gem --source http://rubygems.org
    other_gem >= 1.2.1
    even_more = 0.0.1

    gem dependent XXX --source http://rubygems.org --no-progress | wc -l

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
 - include nested dependencies (a > b > c --> a = [b,c])
 - add tests for cli interface
 - add `--type development` support

Authors
=======

### [Contributors](https://github.com/grosser/gem-dependent/contributors)
 - [Christopher Patuzzo](https://github.com/cpatuzzo)

[Michael Grosser](http://grosser.it)<br/>
michael@grosse.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/gem-dependent.png)](https://travis-ci.org/grosser/gem-dependent)

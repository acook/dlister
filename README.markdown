Dlister
=======

Dlister is basically an 'ls' clone with some enhancements.

*Anthony M. Cook 2013 - http://github.com/acook | @anthony_m_cook | http://anthonymcook.com*

Features
--------

- Unicode sigils
- Improved multi-attribute sorting
- Color
- 256-color support (planned)
- SCM (git) integration (planned)

Installation
------------

To use it as an `ls` replacement, just install the gem:

    $ gem install dlister

And then make a symlink to it (I don't suggest overwriting ls):

    $ alias l='dlister'

Usage
-----

Pretty basic just do `dlister path`. Examples:

    $ dlister                        # list current directory
    $ dlister ~                      # list home directory
    $ dlister /bin ../ .bash_profile # list absolute path, relative path, and file

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

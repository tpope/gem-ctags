RubyGems Automatic Ctags Invoker
================================

Nary a day of Ruby development goes by where I don't run
[`gem open`][gem-browse] or `bundle open`.  And when I go rooting around
in a gem, I want tags.  As good as I've gotten at `ctags -R .`, I've
grown weary of it.  So I wrote a RubyGems plugin to automatically invoke
Ctags on gems as they are installed.

Installation
------------

If you haven't already, install [Exuberant Ctags][] and make sure it
comes first in `$PATH`.  With Homebrew, `brew install ctags`.  Now all
that's left to do is install gem-ctags and perform a one-off indexing of
the gems that are already installed:

    gem install gem-ctags
    gem ctags

If you're using RVM, I recommend extending your global gemset by adding
`gem-ctags` to `~/.rvm/gemsets/global.gems`.  Put it at the top so the
gems below it will be indexed.

Troubleshooting
---------------

If you see

    $ ctags -R
    ctags: illegal option -- R
    usage: ctags [-BFadtuwvx] [-f tagsfile] file ...

you do not have the correct version of ctags in your path.

Just add the following to your .bashrc and be happy:

    export PATH=/usr/local/bin:$PATH
    

Vim Tips
--------

To easily edit a gem with your current working directory set to the
gem's root, install [gem-browse][].

If you have [rake.vim][] installed (which, by the way, is a misleading
name), Vim will already know where to look for the tags file when
editing a gem.

If you have [bundler.vim][] installed, Vim will be aware of all tags
files from all gems in your bundle.

If you want to get crazy, add this to your vimrc to get Vim to search
all gems in your current RVM gemset (requires [pathogen.vim][]):

    autocmd FileType ruby let &l:tags = pathogen#legacyjoin(pathogen#uniq(
          \ pathogen#split(&tags) +
          \ map(split($GEM_PATH,':'),'v:val."/gems/*/tags"')))

I don't like to get crazy.

Contributing
------------

Don't submit a pull request with [an ugly commit
message](http://stopwritingramblingcommitmessages.com) or I will ignore
your patch until I have the energy to politely explain my zero tolerance
policy.

License
-------

Copyright (c) Tim Pope.  MIT License.

[Exuberant Ctags]: http://ctags.sourceforge.net/
[gem-browse]: https://github.com/tpope/gem-browse
[bundler.vim]: https://github.com/tpope/vim-bundler
[pathogen.vim]: https://github.com/tpope/vim-pathogen
[rake.vim]: https://github.com/tpope/vim-rake

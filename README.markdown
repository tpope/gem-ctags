RubyGems Automatic Ctags Invoker
================================

Nary a day of Ruby development goes by where I don't run `gem open`.
And when I do, I want tags.  As good as I've gotten at `ctags -R .`,
I've grown weary of it.  So I wrote a RubyGems plugin to automatically
invoke Ctags every time a Gem is installed.

Installation
------------

    gem install gem-ctags

Now all that's left to do is install [Exuberant Ctags][] and make sure
it comes first in `$PATH`.  With Homebrew, `brew install ctags`.

If you're using RVM, I recommend extending your global gemset:

    echo gem-ctags >> ~/.rvm/gemsets/global.gems

To generate tags for all previously installed gems that don't already
have a `tags` file, run `gem ctags`.  (If it blows up, upgrade
RubyGems.)  Future gems will be handled automatically and silently, with
the sad exception of those installed by Bundler (see
[this issue](https://github.com/carlhuda/bundler/pull/1364)).

Vim Tips
--------

If you have [rake.vim][] installed (which, by the way, is a misleading
name), Vim will already know where to look for the tags file when
editing a gem.

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
[pathogen.vim]: https://github.com/tpope/vim-pathogen
[rake.vim]: https://github.com/tpope/vim-rake

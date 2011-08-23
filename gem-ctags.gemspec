# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "gem-ctags"
  s.version     = "1.0.2"
  s.authors     = ["Tim Pope"]
  s.email       = ["ruby@tpop"+'e.org']
  s.homepage    = "https://github.com/tpope/gem-ctags"
  s.summary     = %q{Automatic ctags generation on gem install}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rake')
end

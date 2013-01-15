# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dlister/version'

Gem::Specification.new do |gem|
  gem.name          = 'dlister'
  gem.version       = Dlister::VERSION
  gem.authors       = ['Anthony Cook']
  gem.email         = ['anthonymichaelcook@gmail.com']
  gem.description   = %q{Dlister is sort of an 'ls' clone for Ruby. It has some enhanced features and minor differences. It's killer feature though will be SCM integration (in progress).}
  gem.summary       = %q{Enhanced 'ls' clone.}
  gem.homepage      = 'http://github.com/acook/dlister#readme'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end

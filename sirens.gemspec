# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
    s.name          = 'sirens'
    s.version       = '0.0.1'
    s.licenses      = ['MIT']
    s.summary       = 'Some simple development tools for Ruby.'
    s.description   = 'Interactive tools to develop in Ruby, implemented in Ruby and GTK3.'
    s.authors       = ['Haijin Development', 'Martin Rubi']
    s.email         = 'haijin.development@gmail.com'
    s.files         = `git ls-files -- lib/*`.split("\n")
    s.homepage      = 'https://rubygems.org/gems/sirens'
    s.metadata      = { 'source_code_uri' => 'https://github.com/haijin-development/ruby-sirens' }
    s.require_path  = 'lib'

    s.requirements  << 'gtk3 gobject-introspection'

    s.add_runtime_dependency 'gtk3', '~> 3.0'
end
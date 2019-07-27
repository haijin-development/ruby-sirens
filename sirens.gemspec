# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
    s.name          = 'sirens'
    s.version       = '0.1.1'
    s.licenses      = ['MIT']
    s.summary       = 'Development utilities for Ruby.'
    s.description   = 'Interactive utilities to develop in Ruby, implemented in Ruby and GTK3.'
    s.authors       = ['Haijin Development', 'Martin Rubi']
    s.email         = 'haijin.development@gmail.com'
    s.files         = `git ls-files -- lib/* resources/*`.split("\n")
    s.homepage      = 'https://rubygems.org/gems/sirens'
    s.metadata      = { 'source_code_uri' => 'https://github.com/haijin-development/ruby-sirens' }
    s.require_path  = 'lib'

    s.requirements  << 'gtk3 gobject-introspection method_source'

    s.add_runtime_dependency 'gtk3', '~> 3.0'
    s.add_runtime_dependency 'method_source', '~> 0.9'
end

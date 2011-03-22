# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "keepass/password/version"

Gem::Specification.new do |s|
  s.name        = "keepass-password-generator"
  s.version     = KeePass::Password::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Nishinaga"]
  s.email       = ["jingoro@casa-z.org"]
  s.homepage    = "https://github.com/patdeegan/keepass-password-generator"
  s.summary     = "keepass-password-generator-#{KeePass::Password::VERSION}"
  s.description = "Generate passwords using KeePass password generator patterns"

  s.rubyforge_project = "keepass-password-generator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'activesupport', '>= 2.2.0'

  s.add_development_dependency 'yard'
  s.add_development_dependency 'bluecloth'
  s.add_development_dependency 'rspec'

end

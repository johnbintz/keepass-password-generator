# keepass-password-generator

Generate passwords using KeePass password generator patterns.

## RubyGems installation

    gem install keepass-password-generator

## Bundler installation

In your `Gemfile`:

    gem 'keepass-password-generator'

Install bundled gems:

    bundle

## Usage

    require 'keepass/password'

    KeePass::Password.generate('A{6}s')
    #=> "Un2hd#t"
    
See <http://keepass.info/help/base/pwgenerator.html> for information about KeePass patterns.

## Examples

A 40-bit WEP key:

    KeePass::Password.generate('h{10}')
    #=> "ae6929dc0e"

A random MAC address:

    KeePass::Password.generate('HH\-HH\-HH\-HH\-HH\-HH', :permute => false)
    #=> "0D-4D-32-64-EB-7D"

A password with 10 alphanumeric characters, where at least 2 are upper case and at least are 2 lower case characters:

    KeePass::Password.generate('uullA{6}')
    #=> "us2j1nTIQT"

A password with 20 alphanumeric and symbol characters, without any lookalike characters (e.g., I and |):

    KeePass::Password.generate('[As]{20}', :remove_lookalikes => true)
    #=> "-2~[+Rze{hZezk(\\nZ-W"

Invalid patterns raise an exception:

    KeePass::Password.generate('[\I\|]{3}', :remove_lookalikes => true)
    #=> KeePass::Password::InvalidPatternError: empty character set for token 1 for "[\\I\\|]{3}"

## Related gems

* <https://github.com/dmke/simple-password-gen>
* <http://rubygems.org/gems/ruby-password>

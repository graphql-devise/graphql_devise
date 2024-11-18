#!ruby

ruby_version  = Gem::Version.new(RUBY_VERSION)

if ruby_version < Gem::Version.new('2.6')
  system('gem install bundler -v 2.3.27')
elsif ruby_version >= Gem::Version.new('2.6') && ruby_version < Gem::Version.new('3.0')
  system('gem install bundler -v 2.4.22')
else
  system('gem install bundler')
end

Gem::Specification.new do |s|
  s.name        = 'gmo_payment'
  s.version     = '1.0.0'
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Manh Dao Van'
  s.email       = 'manhdaovan@gmail.com'
  s.homepage    = 'https://manhdaovan.github.io/'
  s.summary     = 'Simple API wrapper for GMO Payment Gateway API request'
  s.description = 'Easy to make request to GMO Payment Gateway via API'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0.0'
  s.add_development_dependency('rake')
end
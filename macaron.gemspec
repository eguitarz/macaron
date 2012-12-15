gemspec = Gem::Specification.new do |s|
  s.name = 'macaron'
  s.version = '2.0.2'
  s.date = '2012-12-11'
  s.authors = ['Dale Ma']
  s.email = 'dalema22@gmail.com'
  s.summary = 'Ruby based web scraper'
  s.homepage = 'https://github.com/eguitarz/macaron'

  s.require_paths = %w(lib)
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = "macaron"

  s.add_dependency('e-threadpool', '~> 1.3.0')
  s.add_dependency('nokogiri', '~> 1.5.5')
  s.add_dependency('watir-webdriver', '~> 0.6.2')
end

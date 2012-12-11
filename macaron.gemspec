gemspec = Gem::Specification.new do |s|
  s.name = 'macaron'
  s.version = '2.0.1'
  s.date = '2012-12-11'
  s.authors = ['Dale Ma']
  s.email = 'dalema22@gmail.com'
  s.summary = 'Ruby based web scraper'
  s.homepage = 'http://github.com/eguitarz/macaron'

  s.require_paths = %w(lib)
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = "macaron"
end

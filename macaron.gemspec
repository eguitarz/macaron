gemspec = Gem::Specification.new do |s|
  s.name = 'macaron'
  s.version = '1.0.2'
  s.date = '2012-12-06'
  s.authors = ['Dale Ma']
  s.email = 'dalema22@gmail.com'
  s.summary = 'Ruby based web scraper'
  s.homepage = 'http://github.com/eguitarz/macaron'

  s.require_paths = %w(lib)
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = "macaron"
end

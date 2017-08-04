# -*- encoding: utf-8 -*-
# stub: bcrypt-ruby 3.1.1.rc1 ruby lib
# stub: ext/mri/extconf.rb

Gem::Specification.new do |s|
  s.name = "bcrypt-ruby".freeze
  s.version = "3.1.1.rc1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Coda Hale".freeze]
  s.date = "2013-07-10"
  s.description = "    bcrypt() is a sophisticated and secure hash algorithm designed by The OpenBSD project\n    for hashing passwords. bcrypt-ruby provides a simple, humane wrapper for safely handling\n    passwords.\n".freeze
  s.email = "coda.hale@gmail.com".freeze
  s.extensions = ["ext/mri/extconf.rb".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "COPYING".freeze, "CHANGELOG".freeze, "lib/bcrypt/engine.rb".freeze, "lib/bcrypt/error.rb".freeze, "lib/bcrypt/password.rb".freeze, "lib/bcrypt.rb".freeze]
  s.files = ["CHANGELOG".freeze, "COPYING".freeze, "README.md".freeze, "ext/mri/extconf.rb".freeze, "lib/bcrypt.rb".freeze, "lib/bcrypt/engine.rb".freeze, "lib/bcrypt/error.rb".freeze, "lib/bcrypt/password.rb".freeze]
  s.homepage = "http://bcrypt-ruby.rubyforge.org".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "bcrypt-ruby".freeze, "--line-numbers".freeze, "--inline-source".freeze, "--main".freeze, "README.md".freeze]
  s.rubyforge_project = "bcrypt-ruby".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "OpenBSD's bcrypt() password hashing algorithm.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rdoc>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 0"])
  end
end

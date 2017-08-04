# -*- encoding: utf-8 -*-
# stub: honoka-rails 3.3.7 ruby lib

Gem::Specification.new do |s|
  s.name = "honoka-rails".freeze
  s.version = "3.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Shota Iguchi".freeze]
  s.date = "2016-07-31"
  s.description = "To mount Honoka on rails. Honoka is a simple and friendly japanese bootstrap-theme.".freeze
  s.email = ["e.iguchi1124@gmail.com".freeze]
  s.homepage = "https://github.com/iguchi1124/honoka-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "To mount Honoka a simple bootstrap-theme on rails.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<capybara>.freeze, [">= 2.5.0"])
      s.add_development_dependency(%q<poltergeist>.freeze, [">= 0"])
      s.add_development_dependency(%q<actionpack>.freeze, [">= 4.1.5"])
      s.add_development_dependency(%q<activesupport>.freeze, [">= 4.1.5"])
      s.add_development_dependency(%q<json>.freeze, [">= 1.8.1"])
      s.add_development_dependency(%q<sprockets-rails>.freeze, [">= 2.1.3"])
      s.add_development_dependency(%q<jquery-rails>.freeze, [">= 3.1.0"])
      s.add_development_dependency(%q<uglifier>.freeze, [">= 0"])
      s.add_development_dependency(%q<sass-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<coffee-rails>.freeze, [">= 0"])
    else
      s.add_dependency(%q<capybara>.freeze, [">= 2.5.0"])
      s.add_dependency(%q<poltergeist>.freeze, [">= 0"])
      s.add_dependency(%q<actionpack>.freeze, [">= 4.1.5"])
      s.add_dependency(%q<activesupport>.freeze, [">= 4.1.5"])
      s.add_dependency(%q<json>.freeze, [">= 1.8.1"])
      s.add_dependency(%q<sprockets-rails>.freeze, [">= 2.1.3"])
      s.add_dependency(%q<jquery-rails>.freeze, [">= 3.1.0"])
      s.add_dependency(%q<uglifier>.freeze, [">= 0"])
      s.add_dependency(%q<sass-rails>.freeze, [">= 0"])
      s.add_dependency(%q<coffee-rails>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<capybara>.freeze, [">= 2.5.0"])
    s.add_dependency(%q<poltergeist>.freeze, [">= 0"])
    s.add_dependency(%q<actionpack>.freeze, [">= 4.1.5"])
    s.add_dependency(%q<activesupport>.freeze, [">= 4.1.5"])
    s.add_dependency(%q<json>.freeze, [">= 1.8.1"])
    s.add_dependency(%q<sprockets-rails>.freeze, [">= 2.1.3"])
    s.add_dependency(%q<jquery-rails>.freeze, [">= 3.1.0"])
    s.add_dependency(%q<uglifier>.freeze, [">= 0"])
    s.add_dependency(%q<sass-rails>.freeze, [">= 0"])
    s.add_dependency(%q<coffee-rails>.freeze, [">= 0"])
  end
end

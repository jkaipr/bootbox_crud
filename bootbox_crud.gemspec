require File.expand_path('../lib/bootbox_crud/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jiri Kaipr"]
  gem.email         = ["jiri.kaipr@gmail.com"]
  gem.description   = %q{Provides Rails modal CRUD scaffolding powered by bootstrap & bootbox & simple_form. Built for use with Turbolinks, jQuery and Twitter Bootstrap 3.}
  gem.homepage      = "https://github.com/Virtualmaster/bootbox_crud"
  gem.summary       = %q{Rails CRUD scaffold with bootbox modals.}

  gem.name          = "bootbox_crud"
  gem.require_paths = ["lib"]
  gem.files         = `git ls-files`.split("\n")
  gem.version       = BootboxCrud::Rails::VERSION
  gem.platform      = Gem::Platform::RUBY

  gem.add_dependency "railties", ">= 4.0"
  gem.add_dependency "sass-rails", "~> 5.0"
  gem.add_dependency "bootstrap-sass", "~> 3.0"
  gem.add_dependency "haml", "~> 4.0"
  gem.add_dependency "haml-rails", "~> 0.7"
  gem.add_dependency "simple_form", "~> 3.0"
  gem.add_dependency "bootbox-rails", "~> 0.5"
  gem.add_dependency "jquery-rails", ">= 3.0"
  gem.add_dependency "turbolinks", "~> 2.5"
  gem.add_dependency "jquery-turbolinks", "~> 2.1"
  gem.add_dependency "remotipart", "~> 1.2"
  gem.add_development_dependency "bundler", "~> 1.0"
  gem.add_development_dependency "minitest-rails", "~> 2.2"
  gem.add_development_dependency "mocha", "~> 1.1"
end

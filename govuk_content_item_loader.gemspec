lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "govuk_content_item_loader/version"

Gem::Specification.new do |spec|
  spec.name          = "govuk_content_item_loader"
  spec.version       = GovukContentItemLoader::VERSION
  spec.authors       = ["GOV.UK Dev"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]

  spec.summary       = "TODO consistent way"
  spec.homepage      = "https://github.com/alphagov/govuk_content_item_loader"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency "gds-api-adapters", ">= 99.3"

  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "rails" # TODO: constrain this
  spec.add_development_dependency "rake" # TODO: constrain this
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-govuk", "~> 5.2"
  spec.add_development_dependency "simplecov"
end

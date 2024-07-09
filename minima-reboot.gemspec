# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "minima-reboot"
  spec.version       = "1.0.33"
  spec.authors       = ["Alexander Terenin"]
  spec.email         = ["bomin392357@gmail.com"]

  spec.summary       = %q{A Bootstrap port of Minima, Jekyll's default theme.}
  spec.homepage      = "https://github.com/HodelKR/hodelKR.github.io"
  spec.license       = "MIT"

  spec.metadata["plugin_type"] = "theme"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README)}i) }

  spec.add_runtime_dependency "jekyll", ">=  3.6", "< 5.0"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.7"

  spec.add_development_dependency "jekyll-feed", "~> 0.15"
  spec.add_development_dependency "jekyll-paginate", "~> 1.1"
  spec.add_development_dependency "jekyll-redirect-from", "~> 0.16"
  spec.add_development_dependency "kramdown-parser-gfm", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 2.2"
end

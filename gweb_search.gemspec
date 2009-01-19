# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gweb_search}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["YAMAGUCHI Seiji"]
  s.date = %q{2009-01-19}
  s.description = %q{Thin wrapper for Google AJAX Search API.}
  s.email = %q{valda@underscore.jp}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/google", "test/google/test_gweb_search.rb", "lib/google", "lib/google/gweb_search.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://gweb_search.rubyforge.org}
  s.rdoc_options = ["--title", "gweb_search documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gweb_search}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Thin wrapper for Google AJAX Search API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.1.3"])
    else
      s.add_dependency(%q<json>, [">= 1.1.3"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.1.3"])
  end
end

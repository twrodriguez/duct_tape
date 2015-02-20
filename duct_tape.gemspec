# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: duct_tape 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "duct_tape"
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tim Rodriguez"]
  s.date = "2015-02-20"
  s.description = "A general-purpose utility library for Ruby"
  s.email = ["tw.rodriguez@gmail.com"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".gitattributes",
    "Gemfile",
    "LICENSE",
    "README.md",
    "REQUIRED_FILES",
    "Rakefile",
    "VERSION",
    "duct_tape.gemspec",
    "lib/algorithms/containers.rb",
    "lib/algorithms/containers/heap.rb",
    "lib/algorithms/containers/priority_queue.rb",
    "lib/duct_tape.rb",
    "lib/duct_tape/autoassociative_array.rb",
    "lib/duct_tape/fuzzy_hash.rb",
    "lib/ext/array.rb",
    "lib/ext/boolean.rb",
    "lib/ext/datetime.rb",
    "lib/ext/dir.rb",
    "lib/ext/file.rb",
    "lib/ext/hash.rb",
    "lib/ext/kernel.rb",
    "lib/ext/numeric.rb",
    "lib/ext/object.rb",
    "lib/ext/pathname.rb",
    "lib/ext/range.rb",
    "lib/ext/regexp.rb",
    "lib/ext/string.rb",
    "lib/ext/symbol.rb",
    "lib/ext/time.rb",
    "lib/ext/uri.rb",
    "spec/algorithms/containers/heap_spec.rb",
    "spec/algorithms/containers/priority_queue_spec.rb",
    "spec/duct_tape/autoassociative_array_spec.rb",
    "spec/duct_tape/fuzzy_hash.rb",
    "spec/ext/array_spec.rb",
    "spec/ext/boolean_spec.rb",
    "spec/ext/datetime_spec.rb",
    "spec/ext/dir_spec.rb",
    "spec/ext/file_spec.rb",
    "spec/ext/hash_spec.rb",
    "spec/ext/kernel_spec.rb",
    "spec/ext/numeric_spec.rb",
    "spec/ext/object_spec.rb",
    "spec/ext/pathname_spec.rb",
    "spec/ext/range_spec.rb",
    "spec/ext/regexp_spec.rb",
    "spec/ext/string_spec.rb",
    "spec/ext/symbol_spec.rb",
    "spec/ext/time_spec.rb",
    "spec/ext/uri_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/twrodriguez/duct_tape"
  s.licenses = ["Simplified BSD"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.2.2"
  s.summary = "A bunch of useful patches for core Ruby classes"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<facets>, ["~> 2.9.3"])
      s.add_runtime_dependency(%q<backports>, [">= 0"])
      s.add_runtime_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<facets>, ["~> 2.9.3"])
      s.add_dependency(%q<backports>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<facets>, ["~> 2.9.3"])
    s.add_dependency(%q<backports>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end


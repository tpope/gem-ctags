require 'rubygems/command'

class Gem::Commands::CtagsCommand < Gem::Command
  def initialize
    super 'ctags', 'Generate ctags for gems'
  end

  def execute
    Gem::Specification.each do |spec|
      self.class.index(spec) do
        say "Generating ctags for #{spec.full_name}"
      end
    end
  end

  def self.index(spec)
    Dir.chdir(spec.full_gem_path) do
      unless File.exist?('tags')
        yield if block_given?
        paths = spec.require_paths.select { |p| File.directory?(p) }
        system('ctags', '-R', '--languages=ruby', *paths)
      end
    end
  end
end

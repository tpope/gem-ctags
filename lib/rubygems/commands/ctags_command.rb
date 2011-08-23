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
        system('ctags', '-R', '--languages=ruby', *spec.require_paths)
      end
    end
  end
end

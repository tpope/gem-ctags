require 'rubygems/command'

class Gem::Commands::CtagsCommand < Gem::Command
  def initialize
    super 'ctags', 'Generate ctags for gems'
  end

  def execute
    Gem::Specification.each do |spec|
      Dir.chdir(spec.full_gem_path) do
        unless File.exist?('tags')
          say "Generating ctags for #{spec.full_name}"
          system('ctags', '-R', *spec.require_paths)
        end
      end
    end
  end
end

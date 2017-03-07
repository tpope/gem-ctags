require 'pathname'
require 'rubygems/command'

class Gem::Commands::CtagsCommand < Gem::Command
  def initialize
    super 'ctags', 'Generate ctags for gems'
  end

  def execute
    if Gem::Specification.respond_to?(:each)
      Gem::Specification
    else
      Gem.source_index.gems.values
    end.each do |spec|
      self.class.index(spec) do |message|
        say message
      end
    end
  end

  def self.index(spec)
    return unless File.directory?(spec.full_gem_path)

    tag_file = File.expand_path('tags', spec.full_gem_path)
    if !(File.file?(tag_file) && File.read(tag_file, 1) == '!') && !File.directory?(tag_file)
      yield "Generating ctags for #{spec.full_name}" if block_given?
      paths = spec.require_paths.
        map { |p|
          Pathname.new(File.join(spec.full_gem_path, p)).
            relative_path_from(Pathname.pwd).to_s
        }.
        select { |p| File.directory?(p) }
      paths = [spec.full_gem_path] if paths.empty?
      system(
        'ctags', '-R', '--languages=ruby', '--fields=+l', '-f', tag_file, '--tag-relative=yes',
        *paths
      )
    end

    target = File.expand_path('lib/bundler/cli.rb', spec.full_gem_path)
    if File.writable?(target) && !File.read(target).include?('load_plugins')
      yield "Injecting gem-ctags into #{spec.full_name}" if block_given?
      File.open(target, 'a') do |f|
        f.write "\nGem.load_plugins rescue nil\n"
      end
    end
  rescue => e
    raise unless block_given?
    yield "Failed processing ctags for #{spec.full_name}:\n  (#{e.class}) #{e}"
  end
end

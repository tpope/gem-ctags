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
      self.class.index(spec, ui)
    end
  end

  def self.invoke(languages, tag_file, *paths)
    system(
      'ctags',
      "--languages=#{languages}",
      '-R',
      '--tag-relative=yes',
      '-f',
      tag_file.to_s,
      *paths.map { |p| Pathname.new(p).relative_path_from(Pathname.pwd).to_s }
    )
  end

  def self.can_write?(path)
    path.dirname.directory? && !path.directory? &&
      !(path.file? && path.read(1) == '!')
  end

  def self.index(spec, ui = nil)
    gem_path = Pathname.new(spec.full_gem_path)

    tag_file = gem_path.join('tags')
    paths = spec.require_paths.map { |p| gem_path.join(p) }
    if paths.any? && can_write?(tag_file)
      ui.say "Generating ctags for #{spec.full_name}" if ui
      invoke('Ruby', tag_file, *paths)
    end

    target = gem_path.join('lib/bundler/cli.rb')
    if target.writable? && !target.read.include?('load_plugins')
      ui.say "Injecting gem-ctags into #{spec.full_name}" if ui
      target.open('a') do |f|
        f.write "\nGem.load_plugins rescue nil\n"
      end
    end
  rescue => e
    raise unless ui
    ui.say "Failed processing ctags for #{spec.full_name}:\n  (#{e.class}) #{e}"
  end
end

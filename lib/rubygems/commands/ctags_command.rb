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

  def self.index(spec)
    return unless File.directory?(spec.full_gem_path)

    tag_file = File.expand_path('tags', spec.full_gem_path)
    if !(File.file?(tag_file) && File.read(tag_file, 1) == '!') && !File.directory?(tag_file)
      ui.say "Generating ctags for #{spec.full_name}" if ui
      paths = spec.require_paths.
        map { |p|
          Pathname.new(File.join(spec.full_gem_path, p)).
            relative_path_from(Pathname.pwd).to_s
        }.
        select { |p| File.directory?(p) }
      paths = [spec.full_gem_path] if paths.empty?
      system(
        'ctags', '--languages=Ruby', '-R', '--tag-relative=yes', '-f', tag_file,
        *paths
      )
    end

    target = File.expand_path('lib/bundler/cli.rb', spec.full_gem_path)
    if File.writable?(target) && !File.read(target).include?('load_plugins')
      ui.say "Injecting gem-ctags into #{spec.full_name}" if ui
      File.open(target, 'a') do |f|
        f.write "\nGem.load_plugins rescue nil\n"
      end
    end
  rescue => e
    raise unless ui
    ui.say "Failed processing ctags for #{spec.full_name}:\n  (#{e.class}) #{e}"
  end
end

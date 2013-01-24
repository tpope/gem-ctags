require 'rubygems/command'

class Gem::Commands::CtagsCommand < Gem::Command
  def initialize
    super 'ctags', 'Generate ctags for gems'
    add_option('-e', '--emacs',  'Create a tags file suitable for emacs in the current directory') do |value, options|
      options[:emacs] = value
      options[:current_dir] = Dir.getwd
    end
  end

  def execute
    # Record if it's the first time in the loop.
    append = false
    if Gem::Specification.respond_to?(:each)
      Gem::Specification
    else
      Gem.source_index.gems.values
    end.each do |spec|
      self.class.index(spec, options, append) do |message|
        say message
      end
      append = true
    end
  end

  def self.index(spec, options={}, append=false)
    return unless File.directory?(spec.full_gem_path)

    # start building the command
    cmd = ['ctags', '-R', '--languages=ruby']

    if !options[:emacs].nil?
      tag_file = File.join(options[:current_dir], 'TAGS')
      # I remove the file only the first time.
      File.exists?(tag_file) && File.delete(tag_file) unless append
      # and add emacs specific options.
      cmd += ['-f', tag_file, '-e']
    else
      # outside emacs support, one file per directory is created.
      append = false
    end

    Dir.chdir(spec.full_gem_path) do

      if (!File.exist?('tags') || File.read('tags', 1) != '!') || options[:emacs]
        yield "Generating ctags for #{spec.full_name}" if block_given?
        paths = spec.require_paths.select { |p| File.directory?(p) }
        if append
          cmd += ['-a']
        end
        final_cmd = cmd + paths
        system(*final_cmd)
      end

      target = 'lib/bundler/cli.rb'
      if File.writable?(target) && !File.read(target).include?('load_plugins')
        yield "Injecting gem-ctags into #{spec.full_name}" if block_given?
        File.open(target, 'a') do |f|
          f.write "\nGem.load_plugins rescue nil\n"
        end
      end

    end
  end
end

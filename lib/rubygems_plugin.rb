require 'rubygems/command_manager'

Gem::CommandManager.instance.register_command :ctags

Gem.post_install do |installer|
  Dir.chdir(installer.spec.full_gem_path) do
    system('ctags', '-R', *installer.spec.require_paths)
  end
end

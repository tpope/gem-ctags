require 'rubygems/command_manager'
require 'rubygems/commands/ctags_command'

Gem::CommandManager.instance.register_command :ctags

Gem.post_install do |installer|
  Gem::Commands::CtagsCommand.index(installer.spec, installer.ui)
end

require 'rubygems/command_manager'

Gem::CommandManager.instance.register_command :ctags

Gem.post_install do |installer|
  require 'rubygems/commands/ctags_command'
  Gem::Commands::CtagsCommand.index(installer.spec)
end

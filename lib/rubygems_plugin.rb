require "rubygems/version"
require 'rubygems/command_manager'
require 'rubygems/version_option'
require 'rubygems/gem/specification'

Gem::CommandManager.instance.register_command :readme

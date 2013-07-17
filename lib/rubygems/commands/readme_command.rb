class Gem::Commands::ReadmeCommand < Gem::Command
  include Gem::VersionOption

  def initialize
    super("readme",
          "Open the README file of a given gem",
          latest: true,
          version: Gem::Requirement.default,
          editor: ENV['EDITOR'] || "less")

    add_version_option
  end

  def execute
    gem_name, _ = options[:args]
    gem_specification = Gem::Specification.each.detect { |spec| spec.name == gem_name }

    if gem_specification.nil?
      say "Gem '#{gem_name}' not found."
      raise Gem::SystemExitException, 1
    end

    gem_path = gem_specification.full_gem_path
    system "#{options[:editor]} $(find #{gem_path} -type f -iname 'readme.*')"
  end
end

class Gem::Commands::ReadmeCommand < Gem::Command
  include Gem::VersionOption

  def initialize
    super 'readme', 'Open the README file of a given gem',
      :command => nil,
      :version => Gem::Requirement.default,
      :latest  => false,
      :all     => false

    add_version_option
  end

  def arguments
    "GEMNAME"
  end

  def usage
    "#{program_name} GEMNAME"
  end

  def execute
    gem_name, _ = options[:args]
    gem_specification = Gem::Specification.each.select { |spec| spec.name == gem_name }.last

    if gem_specification.nil?
      say "Gem '#{gem_name}' not found."
      raise Gem::SystemExitException, 1
    end

    gem_path = gem_specification.full_gem_path
    exec "#{options[:editor]} $(find #{gem_path} -type f -iname 'readme.*')"
  end
end

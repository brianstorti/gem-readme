class Gem::Commands::ReadmeCommand < Gem::Command
  include Gem::VersionOption

  def initialize
    super("readme",
          "Open the README file of a given gem",
          latest: true,
          version: Gem::Requirement.default,
          editor: ENV['README_EDITOR'] || ENV['EDITOR'] || "less")

    add_version_option
  end

  def execute
    gem_specification = get_gem_specification

    if gem_specification.nil?
      say "Gem '#{gem_name}' not found."
      raise Gem::SystemExitException, 1
    end

    gem_path = gem_specification.full_gem_path
    system "#{options[:editor]} $(find #{gem_path} -type f -iname 'readme.*')"
  end

  def get_gem_specification
    gem_name, _ = options[:args]
    specifications = Gem::Specification.each.select { |spec| spec.name == gem_name }

    return if specifications.empty?
    return specifications.first if specifications.size == 1

    ask_for_specific_version(specifications)
  end
  private :get_gem_specification

  def ask_for_specific_version(gem_specifications)
    say("Choose a version:")
    gem_specifications.each_with_index do |gem_specification, index|
      say("[#{index}] #{gem_specification.version}")
    end

    print ">> "
    index = STDIN.gets.to_i
    gem_specifications[index]
  end
  private :ask_for_specific_version
end

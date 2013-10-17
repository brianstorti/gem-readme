require "ronn"
require "rdoc"
require "ronn/roff"
#
# Add `readme` command to show gem's README.
#
class Gem::Commands::ReadmeCommand < Gem::Command
  def initialize
    super("readme",
          "Open the README file of a given gem",
          editor: ENV["README_EDITOR"] || ENV["EDITOR"] || "less")
  end

  def execute
    gem_specification = get_gem_specification

    if gem_specification.nil?
      say "Gem not found."
      fail Gem::SystemExitException, 1
    end

    gem_path = gem_specification.full_gem_path
    readme = Dir.glob(File.join(gem_path, "readme*"), File::FNM_CASEFOLD).first

    show readme if readme
  end

  private

  def show(path)
    case readme_format path
    when :markdown
      show_markdown path
    when :rdoc
      show_rdoc path
    else
      show_plain path
    end
  end

  def show_markdown(path)
    date = File.ctime(path)
    doc = Ronn::Document.new(path, {"date" => date})
    show_roff doc.convert("roff")
  end

  def show_rdoc(path)
    date = File.ctime(path)
    rdoc = ROFFHtmlMarkup.new(RDoc::Options.new)
    source = File.read(path)
    doc  = rdoc.parse(source)
    heading = doc.select{|item| item.respond_to?(:level) && item.level == 1}.first
    name, section, tagline = sniff(heading.text)
    show_roff create_roff(rdoc.convert(source),
                          name, section, tagline, date: date)
  end

  def sniff(heading)
    case heading
    when /([\w_.\[\]~+=@:-]+)\s*\((\d\w*)\)\s*-+\s*(.*)/
      [$1, $2, $3]
    when /([\w_.\[\]~+=@:-]+)\s+-+\s+(.*)/
      [$1, nil, $3]
    else
      [nil, nil, $1]
    end
  end

  def show_roff(text)
    groff = "groff -Wall -mtty-char -mandoc -Tascii"
    rd, wr = IO.pipe
    if pid = fork
      rd.close
    else
      wr.close
      STDIN.reopen rd
      exec "#{groff} | #{options[:editor]}"
    end
    wr.puts(text)
    if pid
      wr.close
      Process.wait
    end
  end

  def show_plain(path)
    system "#{options[:editor]} #{path}"
  end

  # Create roff from html
  def create_roff(html, name, section, tagline,
                  manual: nil, version: nil, date: nil)
    html = html.gsub(/<\/{0,1}(hr).+?>/, '')
    Ronn::RoffFilter.new(html, name, section, tagline,
                         manual, version, date).to_s
  end

  def readme_format(path)
    case File.extname(path)
    when ".md", ".markdown", ".mdown"
      :markdown
    when ".rdoc"
      :rdoc
    else
      :other
    end
  end

  def get_gem_specification
    gem_name, _ = options[:args]
    specifications = Gem::Specification.each.select { |spec| spec.name == gem_name }

    return if specifications.empty?
    return specifications.first if specifications.size == 1

    ask_for_specific_version(specifications)
  end

  def ask_for_specific_version(gem_specifications)
    say("Choose a version:")
    gem_specifications.each_with_index do |gem_specification, index|
      say("[#{index}] #{gem_specification.version}")
    end

    print ">> "
    index = STDIN.getc.to_i
    gem_specifications[index]
  end

  class ROFFHtmlMarkup < RDoc::Markup::ToHtml
    def accept_heading heading
       level = [6, heading.level].min
       @res << "\n<h#{level}>"
       @res << to_html(heading.text)
       @res << "</h#{level}>\n"
    end
  end

end

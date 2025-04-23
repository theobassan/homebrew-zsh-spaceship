class SpaceshipDirP10k < Formula
  desc "Spaceship Dir P10k"
  homepage "https://github.com/theobassan/zsh-spaceship"
  url "https://github.com/theobassan/zsh-spaceship/releases/download/v0.1.0/v0.1.0-stable.tar.gz"
  sha256 "e0292b8efb0ac240d6f1208e0cf7c7dc1398cd961d400778686bf0e1c6e9630d"
  license "GPL-3.0-only"

  depends_on "spaceship"
  depends_on "zsh-autosuggestions"
  depends_on "zsh-syntax-highlighting"
  depends_on "zsh-completions"
  depends_on "z"
  depends_on "direnv"
  depends_on "mise"
  depends_on "fd"
  depends_on "bat"
  depends_on "tree"
  depends_on "fzf"

  def install
    Dir.glob("**/*.zsh").each do |file|
      # Create the directory structure under the prefix
      target_dir = File.join(prefix, File.dirname(file))
      mkdir_p target_dir
      # Install the file into the corresponding directory
      (target_dir).install file
    end
    #(prefix).install "zsh-aliases.zsh", "zsh-autosuggestions.zsh", "zsh-syntax-highlighting.zsh", "zsh-completions.zsh", "zsh-z.zsh", "zsh-direnv.zsh", "zsh-mise.zsh", "zsh-spaceship-prompt.zsh", "zsh-spaceship.zsh"
  end

  def caveats
    <<~EOS
      To use this script, source it in your .zshrc:
        source #{opt_prefix}/zsh_spaceship.zsh
    EOS
  end

  test do
    Dir.glob("**/*.zsh").each do |file|
      assert_predicate prefix/file, :exist?, "Expected #{file} to be installed in #{prefix}"
    end
  end
end
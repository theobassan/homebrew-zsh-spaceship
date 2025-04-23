class ZshSpaceship < Formula
  desc "ZSH Spaceship"
  homepage "https://github.com/theobassan/zsh-spaceship"
  url "https://github.com/theobassan/zsh-spaceship/releases/download/v0.1.1/v0.1.1-stable.tar.gz"
  sha256 "2e0dd6f3316a6092539fd84eed2dc4bfe1804bf55f29c96841bc7cd455d28009"
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
      target_dir = prefix/File.dirname(file)
      target_dir.mkpath unless target_dir.exist?
      target_dir.install file
    end
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
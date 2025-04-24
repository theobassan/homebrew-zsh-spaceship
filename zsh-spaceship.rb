class ZshSpaceship < Formula
  desc "ZSH Spaceship"
  homepage "https://github.com/theobassan/zsh-spaceship"
  url "https://github.com/theobassan/homebrew-zsh-spaceship/releases/download/v1.1.0/v1.1.0-stable.tar.gz"
  sha256 "3defad2951a3161d7168c67bb8d5b673b625fa240c08db7d8dc5b746ec38f2dd"
  license "GPL-3.0-only"

  depends_on "spaceship"
  depends_on "zsh-autosuggestions"
  depends_on "zsh-syntax-highlighting"
  depends_on "zsh-completions"
  depends_on "zoxide"
  depends_on "direnv"
  depends_on "mise"
  depends_on "fd"
  depends_on "bat"
  depends_on "tree"
  depends_on "fzf"
  depends_on "awscli"

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

      Note: The `google-cloud-sdk` dependency must be installed manually as it is a cask:
        brew install --cask google-cloud-sdk
    EOS
  end
  
  test do
    Dir.glob("**/*.zsh").each do |file|
      assert_predicate prefix/file, :exist?, "Expected #{file} to be installed in #{prefix}"
    end
  end
end
class ZshSpaceship < Formula
  desc "ZSH Spaceship"
  homepage "https://github.com/theobassan/zsh-spaceship"
  url "https://github.com/theobassan/homebrew-zsh-spaceship/releases/download/v1.0.7/v1.0.7-stable.tar.gz"
  sha256 "4616f6b9ae337fc620d865a90c8c3ccf3187b3a090ce9da85cbf080a9728d378"
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
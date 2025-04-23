class ZshSpaceship < Formula
  desc "ZSH Spaceship"
  homepage "https://github.com/theobassan/zsh-spaceship"
  url "https://github.com/theobassan/homebrew-zsh-spaceship/releases/download/v1.0.3/v1.0.3-stable.tar.gz"
  sha256 "94697a39ecbe89f864e2f91dd8ec322f2eabc6c8bcf0effcdfe5c6e1fc208966"
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
  depends_on "gcloud"

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
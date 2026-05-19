class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/dovocoder/wacli"
  license "MIT"
  head "https://github.com/dovocoder/wacli.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/dovocoder/wacli/releases/download/v0.9.2/wacli-darwin-arm64.tar.gz"
      sha256 "44f50bb31de61a4084ef7dc639a384fc33943d85e9be47e80d8cf5549442fd9d"
    end

    on_intel do
      url "https://github.com/dovocoder/wacli/releases/download/v0.9.2/wacli-darwin-amd64.tar.gz"
      sha256 "6721485ee0a1f6f6b1d9cb773623f294d113a2b447394d169d451fdb3b468842"
    end
  end

  on_linux do
    depends_on "go" => :build

    on_arm do
      url "https://github.com/dovocoder/wacli/releases/download/v0.9.2/wacli-linux-arm64.tar.gz"
      sha256 "2ab979813c6a2cbc3c2a89fca8557c357c23e49d28cfb289f9a0fc1ef0219f33"
    end

    on_intel do
      url "https://github.com/dovocoder/wacli/releases/download/v0.9.2/wacli-linux-amd64.tar.gz"
      sha256 "5a62575aee7071a1577277c2407db7a816cce45e0d6956cfca96e8e00f9949ca"
    end
  end

  def install
    if File.exist?("wacli")
      bin.install "wacli"
    else
      ldflags = "-s -w -X main.version=#{version}"
      # GCC 15+ with glibc 2.42+ treats missing-braces in Go's runtime/cgo as errors.
      # See: https://github.com/steipete/wacli/pull/8
      ENV["CGO_ENABLED"] = "1"
      ENV.append "CGO_CFLAGS", "-Wno-error=missing-braces"
      system "go", "build", "-tags", "sqlite_fts5", *std_go_args(ldflags: ldflags), "./cmd/wacli"
    end
  end

  test do
    assert_match "wacli", shell_output("#{bin}/wacli --version")
    assert_match "FTS5", shell_output("#{bin}/wacli doctor")
  end
end

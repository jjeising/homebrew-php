class Php56Xdebug < Formula
  desc "PHP extension for powerful debugging"
  homepage "http://xdebug.org/"
  url "http://xdebug.org/files/xdebug-2.4.1.tgz"
  sha256 "23c8786e0f5aae67b1e5035972bfff282710fb84c483887cebceb8ef5bbdf8ef"

  depends_on "autoconf" => :build
  depends_on "php56" => :build

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-php-config=#{(Formula["php56"]).bin}/php-config",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-xdebug"
    ]

    chdir "xdebug-#{version}" do
      system "phpize"
      system "./configure", *args
      system "make", "install"
    end
  end
end

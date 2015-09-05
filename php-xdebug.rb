class PhpXdebug < Formula
  desc "PHP extension for powerful debugging"
  homepage "http://xdebug.org/"
  url "http://xdebug.org/files/xdebug-2.3.3.tgz"
  sha256 "b27bd09b23136d242dbc94f4503c98f012a521d5597002c9d463a63c6b0cdfe3"

  depends_on "autoconf" => :build

  depends_on "php"

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-php-config=#{(Formula["php"]).bin}/php-config",
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

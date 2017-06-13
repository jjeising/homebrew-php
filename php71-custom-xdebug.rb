class Php71CustomXdebug < Formula
  desc "PHP extension for powerful debugging"
  homepage "http://xdebug.org/"
  url "http://xdebug.org/files/xdebug-2.5.4.tgz"
  sha256 "300ca6fc3d95025148b0b5d0c96e14e54299e536a93a5d68c67b2cf32c9432b8"

  depends_on "autoconf" => :build
  depends_on "php71-custom" => :build

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-php-config=#{(Formula["php71-custom"]).bin}/php-config",
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

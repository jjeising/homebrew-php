require 'formula'

class PhpXdebug < Formula
  homepage 'http://xdebug.org/'
  url 'http://xdebug.org/files/xdebug-2.2.3.tgz'
  sha1 '045dee86f69051d7944da594db648b337a97f48a'

  depends_on 'php'

  def install
    Dir.chdir "xdebug-#{version}"
    
    system "phpize"
    
    system "./configure", "--prefix=#{prefix}",
                          "--with-php-config=#{(Formula.factory('php')).bin}/php-config",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-xdebug"
    system "make", "install"
  end
end

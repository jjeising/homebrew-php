require 'formula'

class PhpXdebug < Formula
  homepage 'http://xdebug.org/'
  url 'http://xdebug.org/files/xdebug-2.2.5.tgz'
  sha1 '62d388e07a45cab9eee498e7905c92a7e5d023cc'

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

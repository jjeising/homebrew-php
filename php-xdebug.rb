require 'formula'

class PhpXdebug < Formula
  homepage 'http://xdebug.org/'
  url "http://xdebug.org/files/xdebug-2.3.3.tgz"
  sha256 "b27bd09b23136d242dbc94f4503c98f012a521d5597002c9d463a63c6b0cdfe3"

  depends_on 'autoconf' => :build
  
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

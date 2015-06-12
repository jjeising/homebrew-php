require 'formula'

class PhpXdebug < Formula
  homepage 'http://xdebug.org/'
  url 'http://xdebug.org/files/xdebug-2.3.2.tgz'
  sha256 'f875d0f8c4e96fa7c698a461a14faa6331694be231e2ddc4f3de0733322fc6d0'

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

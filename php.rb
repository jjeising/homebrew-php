require 'formula'

class PhpApcu < Formula
  homepage 'https://github.com/krakjoe/apcu'
  url 'http://pecl.php.net/get/apcu-4.0.2.tgz'
  sha1 'dd8a2ed00304501318f678a7f5b7364af4fc7dcf'
end

class PhpIgbinary < Formula
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  sha1 'cebe34d18dd167a40a712a6826415e3e5395ab27'
end

class PhpImagick < Formula
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.1.2.tgz'
  sha1 '7cee88bc8f6f178165c9d43e302d99cedfbb3dff'
end

class PhpMemcached < Formula
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.1.0.tgz'
  sha1 '16fac6bfae8ec7e2367fda588b74df88c6f11a8e'
end

class PhpSsh2 < Formula
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.12.tgz'
  sha1 'b86a25bdd3f3558bbcaaa6d876309fbbb5ae134d'
end

class PhpXdiff < Formula
  homepage 'http://pecl.php.net/package/xdiff'
  url 'http://pecl.php.net/get/xdiff-1.5.2.tgz'
  sha1 '5baa9716fc951d2e3f4e8e73b491493f7d3c3c80'
end

class PhpXhp < Formula
  homepage 'https://github.com/facebook/xhp'
  url 'https://github.com/facebook/xhp/archive/1.4.tar.gz'
  sha1 '6004408583ecc109060321be546b20e85ad36263'
end

class PhpXhprof < Formula
  homepage 'http://pecl.php.net/package/xhprof'
  url 'http://pecl.php.net/get/xhprof-0.9.4.tgz'
  sha1 '1dfd36dd6f85accc64060e4b52bf17bc4c85e694'
end

class Php < Formula
  homepage 'http://php.net/'
  url 'http://de.php.net/distributions/php-5.5.12.tar.gz'
  sha1 'aed3c850e219689408efc36ea75b74526e3a150a'
  
  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn
  
  depends_on 'pkg-config' => :build
  
  depends_on 'autoconf'
  depends_on 'curl'
  depends_on 'freetype'
  depends_on 'gettext'
  depends_on 'icu4c'
  depends_on 'imagemagick'
  depends_on 'imap-uw'
  depends_on 'jpeg'
  depends_on 'libxdiff'
  depends_on 'libxml2'
  depends_on 'mcrypt'
  depends_on 'zeromq'
  
  # mysql/pgsql dependencies?
  
  depends_on 'libmemcached'
  depends_on 'libssh2'
  
  # XHP dependency
  depends_on 're2c'
  
  def config_path
    etc + "php"
  end
  
  def install
    ext = Pathname.new(pwd) + 'ext/'
    
    args = [
      "--localstatedir=#{var}",
      "--mandir=#{man}",
      "--prefix=#{prefix}",
      
      "--sysconfdir=#{config_path}",
      "--with-config-file-path=#{config_path}",
      
      "--disable-debug",
      "--disable-mbregex",
      "--enable-apcu",
      "--enable-bcmath",
      "--enable-calendar",
      "--enable-ctype",
      "--enable-exif",  
      "--enable-fpm",
      "--enable-gd-native-ttf",
      "--enable-igbinary",
      "--enable-mbstring",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-soap",
      "--enable-sockets",
      "--enable-sysvmsg",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-xhp",
      "--enable-xhprof",
      "--enable-zend-signals",
      "--enable-zip",
      "--with-bz2=/usr",
      "--with-curl=#{Formula.factory('curl').prefix}",
      "--with-freetype-dir=#{Formula.factory('freetype').prefix}",
      "--with-gd",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-iconv-dir=/usr",
      "--with-imagick",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-libedit",
      "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
      "--with-mcrypt=#{Formula.factory('mcrypt').prefix}",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysql=mysqlnd",
      "--with-mysqli=mysqlnd",
      "--with-openssl=/usr",
      "--with-pdo-mysql=mysqlnd",
      "--with-pdo-pgsql",
      "--with-png-dir=/usr/X11",
      "--with-snmp=/usr",
      "--with-ssh2",
      "--with-xdiff",
      "--with-xmlrpc",
      "--with-xsl=/usr",
      "--with-zlib=/usr"
    ]
    
    PhpApcu.new.brew { (ext/'apcu').install Dir['apcu*/*'] }
    PhpIgbinary.new.brew { (ext/'igbinary').install Dir['igbinary*/*'] }
    PhpImagick.new.brew { (ext/'imagick').install Dir['imagick*/*'] }
    PhpMemcached.new.brew { (ext/'memcached').install Dir['memcached*/*'] }
    PhpSsh2.new.brew { (ext/'ssh2').install Dir['ssh2*/*'] }
    PhpXdiff.new.brew { (ext/'xdiff').install Dir['xdiff*/*'] }
    PhpXhprof.new.brew { (ext/'xhprof').install Dir['xhprof*/extension/*'] }
    PhpXhp.new.brew { (ext/'xhp').install Dir['*'] }
    
    system "rm configure"
    system "./buildconf --force"
    
    system "./configure", *args
    
    system "make"
    
    ENV.deparallelize
    system "make install"
    
    config_path.install "./php.ini-development" => "php.ini" unless File.exists? config_path + "php.ini"
    config_path.install "sapi/fpm/php-fpm.conf" unless File.exists? config_path + "php-fpm.conf"
  end
end
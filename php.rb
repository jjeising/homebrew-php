require 'formula'

class PhpApc < Formula
  homepage 'http://pecl.php.net/package/apc'
  url 'http://pecl.php.net/get/APC-3.1.13.tgz'
  sha1 'cafd6ba92ac1c9f500a6c1e300bbe8819daddfae'
end

class PhpIgbinary < Formula
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  sha1 'cebe34d18dd167a40a712a6826415e3e5395ab27'
end

class PhpImagick < Formula
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  sha1 '29b6dcd534cde6b37ebe3ee5077b71a9eed685c2'
end

class PhpMemcached < Formula
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.1.0.tgz'
  sha1 '16fac6bfae8ec7e2367fda588b74df88c6f11a8e'
  
  depends_on 'libmemcached'
end

class Php < Formula
  homepage 'http://php.net/'
  url 'http://de.php.net/distributions/php-5.4.7.tar.gz'
  md5 '94661b761dcfdfdd5108e8b12e0dd4f8'
  version '5.4.7'
  
  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn

  # So PHP extensions don't report missing symbols
  skip_clean ['bin', 'sbin']

  depends_on 'gettext'
  depends_on 'icu4c'
  depends_on 'imap-uw'
  depends_on 'jpeg'
  depends_on 'libxml2'
  depends_on 'mcrypt'
  depends_on 'imagemagick'
  #depends_on 'readline'
  depends_on 'autoconf'
  
  def config_path
    etc + "php"
  end
  
  def install
    ext = Pathname.new(pwd) + 'ext/'
    
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--localstatedir=#{var}",
      "--sysconfdir=#{config_path}",
      "--with-config-file-path=#{config_path}",
      "--with-iconv-dir=/usr",
      "--enable-exif",  
      "--enable-soap",
      "--enable-sockets",
      "--enable-zip",
      "--enable-shmop",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-sysvmsg",
      "--enable-mbstring",
      "--disable-mbregex",
      "--enable-zend-signals",
      "--enable-bcmath",
      "--enable-calendar",
      "--with-openssl=/usr",
      "--with-zlib=/usr",
      "--with-bz2=/usr",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-xmlrpc",
      "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
      "--with-xsl=/usr",
      "--with-curl=/usr",
      "--with-gd",
      "--enable-gd-native-ttf",
      "--with-freetype-dir=/usr/X11",
      "--with-mcrypt=#{Formula.factory('mcrypt').prefix}",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-png-dir=/usr/X11",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-snmp=/usr",
      "--mandir=#{man}",
      "--with-libedit",
      "--enable-ctype",
      "--with-imagick",
      "--enable-apc",
      "--enable-igbinary",
      #"--enable-http",
      #"--with-http-zlib-compression",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysqli=mysqlnd",
      "--with-mysql=mysqlnd",
      "--with-pdo-mysql=mysqlnd",
      "--enable-fpm"
    ]
    
    PhpApc.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'apc/']}] }
    PhpIgbinary.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'igbinary/']}] }
    PhpImagick.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'imagick/']}] }
    PhpMemcached.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'memcached/']}] }
    
    # build new configure to include extensions above
    system "rm configure"
    system "./buildconf --force"
    
    system "./configure", *args
    
    system "make"
    ENV.deparallelize # parallel install fails on some systems
    system "make install"
    
    config_path.install "./php.ini-development" => "php.ini" unless File.exists? config_path + "php.ini"
    config_path.install "sapi/fpm/php-fpm.conf" unless File.exists? config_path + "php-fpm.conf"
  end
end

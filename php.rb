require 'formula'

# class PhpApc < Formula
  # homepage 'http://pecl.php.net/package/apc'
  # url 'http://pecl.php.net/get/APC-3.1.13.tgz'
  # sha1 'cafd6ba92ac1c9f500a6c1e300bbe8819daddfae'
# end

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
end

class PhpSsh2 < Formula
  homepage ''
  url 'http://pecl.php.net/get/ssh2-0.12.tgz'
  sha1 'b86a25bdd3f3558bbcaaa6d876309fbbb5ae134d'
end

class PhpZmq < Formula
  homepage 'https://github.com/mkoppanen/php-zmq'
  url 'https://github.com/mkoppanen/php-zmq/archive/1.0.5.zip'
  sha1 '4ae577ef0c3b9f54e5d18b0bc3c1db4616c17cfc'
end

class Php < Formula
  homepage 'http://php.net/'
  url 'http://de.php.net/distributions/php-5.5.2.tar.bz2'
  sha1 '94f42a7807ae21b3a547bf69310dc454f613fe1f'
  version '5.5.2'
  
  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn
  
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'icu4c'
  depends_on 'imap-uw'
  depends_on 'jpeg'
  depends_on 'libxml2'
  depends_on 'mcrypt'
  depends_on 'imagemagick'
  depends_on 'autoconf'
  depends_on 'zeromq'
  
  # mysql/pgsql dependencies?
  
  depends_on 'libmemcached'
  depends_on 'libssh2'
  
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
      # "--enable-apc",
      "--enable-igbinary",
      "--with-ssh2",
      #"--enable-http",
      #"--with-http-zlib-compression",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysqli=mysqlnd",
      "--with-mysql=mysqlnd",
      "--with-pdo-mysql=mysqlnd",
      "--with-pdo-pgsql",
      "--enable-fpm",
      "--with-zmq",
      "--enable-pcntl"
    ]
    
    # PhpApc.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'apc/'] if File.directory? x}] }
    PhpIgbinary.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'igbinary/']  if File.directory? x}] }
    PhpImagick.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'imagick/'] if File.directory? x}] }
    PhpMemcached.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'memcached/'] if File.directory? x}] }
    PhpSsh2.new.brew { ext.install Hash[Dir['*'].map {|x| [x, 'ssh2/'] if File.directory? x}] }
    PhpZmq.new.brew { (ext/'zmq').install Dir['*'] }
    
    # build new configure to include extensions above
    system "rm configure"
    system "./buildconf --force"
    
    system "./configure", *args
    
    system "make"
    #ENV.deparallelize # parallel install fails on some systems
    system "make install"
    
    config_path.install "./php.ini-development" => "php.ini" unless File.exists? config_path + "php.ini"
    config_path.install "sapi/fpm/php-fpm.conf" unless File.exists? config_path + "php-fpm.conf"
  end
end

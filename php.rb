require 'formula'

class Php < Formula
  homepage 'http://php.net/'
  
  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn
  
  url 'http://php.net/distributions/php-5.6.5.tar.gz'
  sha1 '7adaa68b2fc2d6827e65f18d19471def708ecd9d'
  depends_on 'pkg-config' => :build
  
  depends_on 'curl'
  depends_on 'freetype'
  depends_on 'gettext'
  depends_on 'icu4c'
  depends_on 'imagemagick'
  depends_on 'imap-uw'
  depends_on 'jpeg'
  depends_on 'libmemcached'
  depends_on 'libssh2'
  depends_on 'libxdiff'
  depends_on 'libxml2'
  # depends_on 'net-snmp'
  depends_on 'openssl'
  depends_on 'zeromq'
  depends_on 'autoconf'
  
  # mysql/pgsql dependencies?
  
  # XHP dependency
  # depends_on 're2c'
  
  resource 'apcu' do
    url 'http://pecl.php.net/get/apcu-4.0.6.tgz'
    sha1 'f4841f20b333638381b3180ffa1f66b69de1de0f'
  end
  
  resource 'igbinary' do
    url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
    sha1 'cebe34d18dd167a40a712a6826415e3e5395ab27'
  end
  
  resource 'imagick' do
    url 'http://pecl.php.net/get/imagick-3.1.2.tgz'
    sha1 '7cee88bc8f6f178165c9d43e302d99cedfbb3dff'
  end
  
  resource 'memcached' do
    url 'http://pecl.php.net/get/memcached-2.2.0.tgz'
    sha1 '402d7c4841885bb1d23094693f4051900f8f40a8'
  end
  
  #resource 'msgpack' do
  #  url 'http://pecl.php.net/get/msgpack-0.5.5.tgz'
  #  sha1 '67c83c359619e8f7f153a83bdf3708c5ff39e491'
  #end
  
  resource 'ssh2' do
    url 'http://pecl.php.net/get/ssh2-0.12.tgz'
    sha1 'b86a25bdd3f3558bbcaaa6d876309fbbb5ae134d'
  end
  
  resource 'xdiff' do
    url 'http://pecl.php.net/get/xdiff-1.5.2.tgz'
    sha1 '5baa9716fc951d2e3f4e8e73b491493f7d3c3c80'
  end
  
  #resource 'xhp' do
  #  url 'https://github.com/facebook/xhp/archive/1.5.zip'
  #  sha1 'b7df94608da6ae84b0f68e8e986f586f49f5851e'
  #end
  
  resource 'xhprof' do
    url 'http://pecl.php.net/get/xhprof-0.9.4.tgz'
    sha1 '1dfd36dd6f85accc64060e4b52bf17bc4c85e694'
  end
  
  def config_path
    etc + "php"
  end
  
  def install
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
      "--enable-intl",
      "--enable-mbstring",
      "--enable-memcached",
      "--enable-memcached-igbinary",
      "--enable-memcached-json",
      # "--enable-memcached-msgpack",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-soap",
      "--enable-sockets",
      "--enable-sysvmsg",
      "--enable-sysvsem",
      "--enable-sysvshm",
      # "--enable-xhp",
      "--enable-xhprof",
      "--enable-zend-signals",
      "--enable-zip",
      "--with-bz2=/usr",
      "--with-curl=#{Formula.factory('curl').prefix}",
      "--with-freetype-dir=#{Formula.factory('freetype').prefix}",
      "--with-gd",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-gmp",
      "--with-iconv-dir=/usr",
      "--with-imagick",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-libedit",
      "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
      # "--with-msgpack",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysql=mysqlnd",
      "--with-mysqli=mysqlnd",
      "--with-openssl=#{Formula.factory('openssl').prefix}",
      "--with-pdo-mysql=mysqlnd",
      "--with-pdo-pgsql",
      "--with-png-dir=/usr/X11",
      # "--with-snmp=#{Formula.factory('net-snmp').prefix}",
      "--with-ssh2",
      "--with-xdiff",
      "--with-xmlrpc",
      "--with-xsl=/usr",
      "--with-zlib=/usr"
    ]
    
    ext = Pathname.new(pwd) + "ext/"
    
    resources.each do |r|
      r.stage { (ext/r.name).install Dir["#{r.name}*/*"] } unless r.name == "xhprof"
    end
    
    resource("xhprof").stage { (ext/"xhprof").install Dir["xhprof*/extension/*"] }
    # resource("xhp").stage { (ext/"xhp").install Dir["*"] }
    
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
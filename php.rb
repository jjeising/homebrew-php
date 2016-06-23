class Php < Formula
  desc "PHP is a popular general-purpose scripting language"
  homepage "http://php.net/"
  url "http://php.net/distributions/php-5.6.23.tar.gz"
  sha256 "5f2274a13970887e8c81500c2afe292d51c3524d1a06554b0a87c74ce0a24ffe"

  head "https://git.php.net/repository/php-src.git"

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "icu4c"
  depends_on "imagemagick"
  depends_on "imap-uw"
  depends_on "jpeg"
  depends_on "libiconv"
  depends_on "libmemcached"
  depends_on "libssh2"
  depends_on "libxdiff"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "net-snmp"
  depends_on "openldap"
  depends_on "openssl"
  depends_on "zeromq"

  # mysql/pgsql dependencies?

  resource "apcu" do
    url "http://pecl.php.net/get/apcu-4.0.6.tgz"
    sha1 "f4841f20b333638381b3180ffa1f66b69de1de0f"
  end

  resource "igbinary" do
    url "http://pecl.php.net/get/igbinary-1.1.1.tgz"
    sha1 "cebe34d18dd167a40a712a6826415e3e5395ab27"
  end

  resource "imagick" do
    url "http://pecl.php.net/get/imagick-3.1.2.tgz"
    sha1 "7cee88bc8f6f178165c9d43e302d99cedfbb3dff"
  end

  resource "memcached" do
    url "http://pecl.php.net/get/memcached-2.2.0.tgz"
    sha1 "402d7c4841885bb1d23094693f4051900f8f40a8"
  end

  # resource "msgpack" do
  #   url "http://pecl.php.net/get/msgpack-0.5.5.tgz"
  #   sha1 "67c83c359619e8f7f153a83bdf3708c5ff39e491"
  # end

  resource "ssh2" do
    url "http://pecl.php.net/get/ssh2-0.12.tgz"
    sha1 "b86a25bdd3f3558bbcaaa6d876309fbbb5ae134d"
  end

  resource "xdiff" do
    url "http://pecl.php.net/get/xdiff-1.5.2.tgz"
    sha1 "5baa9716fc951d2e3f4e8e73b491493f7d3c3c80"
  end

  resource "xhprof" do
    url "http://pecl.php.net/get/xhprof-0.9.4.tgz"
    sha1 "1dfd36dd6f85accc64060e4b52bf17bc4c85e694"
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
      "--enable-xhprof",
      "--enable-zend-signals",
      "--enable-zip",
      "--with-bz2=#{MacOS.sdk_path}/usr",
      "--with-curl=#{Formula["curl"].prefix}",
      "--with-freetype-dir=#{Formula["freetype"].prefix}",
      "--with-gd",
      "--with-gettext=#{Formula["gettext"].prefix}",
      "--with-gmp",
      "--with-iconv=#{Formula["libiconv"].prefix}",
      "--with-imagick",
      "--with-jpeg-dir=#{Formula["jpeg"].prefix}",
      "--with-ldap=#{Formula["openldap"].prefix}",
      "--with-ldap-sasl=#{MacOS.sdk_path}/usr",
      "--with-libedit=#{MacOS.sdk_path}/usr",
      "--with-libxml-dir=#{Formula["libxml2"].prefix}",
      # "--with-msgpack",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysql=mysqlnd",
      "--with-mysqli=mysqlnd",
      "--with-openssl=#{Formula["openssl"].prefix}",
      "--with-pdo-mysql=mysqlnd",
      "--with-pdo-pgsql",
      "--with-png-dir=#{MacOS.sdk_path}/usr",
      "--with-snmp=#{Formula["net-snmp"].prefix}",
      "--with-ssh2",
      "--with-xdiff",
      "--with-xmlrpc",
      "--with-xsl=#{Formula["libxslt"].prefix}",
      "--with-zlib=#{MacOS.sdk_path}/usr"
    ]

    ext = Pathname.new(pwd) + "ext/"

    resources.each do |r|
      r.stage { (ext/r.name).install Dir["#{r.name}*/*"] } unless r.name == "xhprof"
    end

    resource("xhprof").stage { (ext/"xhprof").install Dir["xhprof*/extension/*"] }

    rm "configure"
    system "./buildconf", "--force"

    system "./configure", *args

    system "make"

    ENV.deparallelize
    system "make", "install"

    config_path.install "./php.ini-development" => "php.ini" unless File.exist? config_path + "php.ini"
    config_path.install "sapi/fpm/php-fpm.conf" unless File.exist? config_path + "php-fpm.conf"
  end

  test do
    assert_equal "php", shell_output("#{bin}/php -r \"echo 'php';\"").strip
  end
end

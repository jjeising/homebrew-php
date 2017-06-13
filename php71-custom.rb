class Php71Custom < Formula
  desc "PHP is a popular general-purpose scripting language"
  homepage "http://php.net/"
  url "http://php.net/distributions/php-7.1.6.tar.bz2"
  sha256 "6e3576ca77672a18461a4b089c5790647f1b2c19f82e4f5e94c962609aabffcf"

  head "https://git.php.net/repository/php-src.git"

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "imagemagick"
  depends_on "imap-uw"
  depends_on "jpeg"
  depends_on "libmemcached"
  depends_on "libssh2"
  depends_on "libxdiff"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "mysql"
  depends_on "net-snmp"
  depends_on "openldap"
  depends_on "openssl"
  depends_on "postgresql"
  depends_on "zeromq"

  resource "apcu" do
    url "http://pecl.php.net/get/apcu-5.1.5.tgz"
    sha256 "5f4153fe21745a44f1d92431b05a85c0912bb3235110615db84a4a6e84fb6791"
  end

  resource "igbinary" do
    url "https://github.com/igbinary/igbinary/archive/2.0.4.tar.gz"
    sha256 "7b71e60aeada2b9729f55f3552da28375e3c5c66194b2c905af15c3756cf34c8"
  end

  resource "imagick" do
    url "https://pecl.php.net/get/imagick-3.4.3RC2.tgz"
    sha256 "beb00413702d479536a032be34294b6006fe0d8feab5c7d8af3dfa4fc6c370ab"
  end

  resource "memcached" do
    url "https://github.com/php-memcached-dev/php-memcached/archive/583ecd68faec886ac9233277531f78fb6e2043c7.zip"
    sha256 "165c43b3d3b7d8da7df0ebbe0551d1a5ac6417e254ed2d86cb9d9b79815ecaf1"
  end

  resource "msgpack" do
    url "http://pecl.php.net/get/msgpack-2.0.2.tgz"
    sha256 "b04980df250214419d9c3d9a5cb2761047ddf5effe5bc1481a19fee209041c01"
  end

  resource "php-ast" do
    url "https://github.com/nikic/php-ast/archive/v0.1.2.tar.gz"
    sha256 "3c22f06354e249324384497af56635d06666c9d2108f52ba79a86e5807246496"
  end

  resource "ssh2" do
    url "http://pecl.php.net/get/ssh2-1.0.tgz"
    sha256 "6a93891878b23904a773eb814fec7aea4ea00b4a412ee779c8535ed9c5e46ced"
  end

  resource "xdiff" do
    url "http://pecl.php.net/get/xdiff-2.0.1.tgz"
    sha256 "b4ac96c33ec28a5471b6498d18c84a6ad0fe2e4e890c93df08e34061fba7d207"
  end

  def config_path
    etc/"php/7.1/"
  end

  def install
    args = [
      "--localstatedir=#{var}",
      "--mandir=#{man}",
      "--prefix=#{prefix}",

      "--sysconfdir=#{config_path}",
      "--with-config-file-path=#{config_path}",
      "--with-config-file-scan-dir=#{config_path}conf.d/",

      "--disable-debug",
      "--disable-mbregex",

      "--enable-apcu",
      "--enable-ast",
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
      "--enable-memcached-msgpack",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-soap",
      "--enable-sockets",
      "--enable-sysvmsg",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-zend-signals",
      "--enable-zip",
      
      "--with-bz2=#{MacOS.sdk_path}/usr",
      "--with-curl=#{Formula["curl"].opt_prefix}",
      "--with-freetype-dir=#{Formula["freetype"].opt_prefix}",
      "--with-gd",
      "--with-gettext=#{Formula["gettext"].opt_prefix}",
      "--with-gmp",
      "--with-iconv-dir=/usr",
      "--with-imagick",
      "--with-jpeg-dir=#{Formula["jpeg"].opt_prefix}",
      "--with-ldap=#{Formula["openldap"].opt_prefix}",
      "--with-ldap-sasl=#{MacOS.sdk_path}/usr",
      "--with-libedit=#{MacOS.sdk_path}/usr",
      "--with-libxml-dir=#{Formula["libxml2"].opt_prefix}",
      "--with-msgpack",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysqli=mysqlnd",
      "--with-openssl=#{Formula["openssl"].opt_prefix}",
      "--with-pdo-mysql=mysqlnd",
      "--with-pdo-pgsql",
      "--with-png-dir=#{MacOS.sdk_path}/usr",
      "--with-snmp=#{Formula["net-snmp"].opt_prefix}",
      "--with-ssh2",
      "--with-xdiff",
      "--with-xmlrpc",
      "--with-xsl=#{Formula["libxslt"].opt_prefix}",
      "--with-zlib=#{MacOS.sdk_path}/usr",
    ]

    ext = Pathname.new(pwd) + "ext/"

    resources.each do |r|
      r.stage { (ext/r.name).install Dir["#{r.name}*/*"] } unless ["igbinary", "memcached", "php-ast"].include?(r.name)
    end

    resource("igbinary").stage { (ext/"igbinary").install Dir["*"] }
    resource("memcached").stage { (ext/"memcached").install Dir["*"] }
    resource("php-ast").stage { (ext/"php-ast").install Dir["*"] }

    rm "configure"
    system "./buildconf", "--force"

    system "./configure", *args

    system "make"
    system "make", "install"

    config_path.install "./php.ini-development" => "php.ini" unless File.exist? config_path + "/php.ini"
    config_path.install "sapi/fpm/php-fpm.conf" unless File.exist? config_path + "/php-fpm.conf"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/php-fpm</string>
            <string>-F</string>
            <string>--fpm-config</string>
            <string>#{config_path}/php-fpm.conf</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_equal "php", shell_output("#{bin}/php -r \"echo 'php';\"").strip
  end
end

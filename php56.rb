class Php56 < Formula
  desc "PHP is a popular general-purpose scripting language"
  homepage "http://php.net/"
  url "http://php.net/distributions/php-5.6.30.tar.gz"
  sha256 "8bc7d93e4c840df11e3d9855dcad15c1b7134e8acf0cf3b90b932baea2d0bde2"

  head "https://git.php.net/repository/php-src.git"

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "freetype"
  depends_on "gettext"
  depends_on 'gmp'
  depends_on "icu4c"
  depends_on "imagemagick@6"
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
    url "http://pecl.php.net/get/apcu-4.0.6.tgz"
    sha256 "4c757df0b90e855a1f9cf160d8d697f53f74e60f44bd93080cfb12f838d1027e"
  end

  resource "igbinary" do
    url "http://pecl.php.net/get/igbinary-1.1.1.tgz"
    sha256 "b84158410bde9db42e7a96c4e947da4569519ab4e7e19a5e3d1db698aac94101"
  end

  resource "imagick" do
    url "http://pecl.php.net/get/imagick-3.1.2.tgz"
    sha256 "528769ac304a0bbe9a248811325042188c9d16e06de16f111fee317c85a36c93"
  end

  resource "memcached" do
    url "http://pecl.php.net/get/memcached-2.2.0.tgz"
    sha256 "17b9600f6d4c807f23a3f5c45fcd8775ca2e61d6eda70370af2bef4c6e159f58"
  end

  resource "ssh2" do
    url "http://pecl.php.net/get/ssh2-0.12.tgz"
    sha256 "600c82d2393acf3642f19914f06a7afea57ee05cb8c10e8a5510b32188b97f99"
  end

  resource "xdiff" do
    url "http://pecl.php.net/get/xdiff-1.5.2.tgz"
    sha256 "ebe72b887fcd2296f1e4032d476a8a463803ccfb0b34b403be8433daf3cfd81d"
  end

  resource "xhprof" do
    url "http://pecl.php.net/get/xhprof-0.9.4.tgz"
    sha256 "002a2d4a825d16aeb3017c59f94d8c5e5d06611dd6197acd2f07fce197d3b8f8"
  end

  def config_path
    etc/"php5"
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
      "--with-curl=#{Formula["curl"].opt_prefix}",
      "--with-freetype-dir=#{Formula["freetype"].opt_prefix}",
      "--with-gd",
      "--with-gettext=#{Formula["gettext"].opt_prefix}",
      "--with-gmp",
      "--with-iconv-dir=/usr",
      "--with-imagick=#{Formula['imagemagick@6'].opt_prefix}",
      "--with-imap=#{Formula['imap-uw'].opt_prefix}",
      "--with-imap-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-jpeg-dir=#{Formula["jpeg"].opt_prefix}",
      "--with-kerberos",
      "--with-ldap=#{Formula["openldap"].opt_prefix}",
      "--with-ldap-sasl=#{MacOS.sdk_path}/usr",
      "--with-libedit=#{MacOS.sdk_path}/usr",
      "--with-libxml-dir=#{Formula["libxml2"].opt_prefix}",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysql=mysqlnd",
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

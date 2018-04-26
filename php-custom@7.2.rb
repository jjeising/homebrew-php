class PhpCustomAT72 < Formula
  desc "PHP is a popular general-purpose scripting language"
  homepage "http://php.net/"
  url "http://php.net/distributions/php-7.2.5.tar.bz2"
  sha256 "f3820efa8efa79628b6e1b5b2f8c1b04c08d32e6721fa1654039ce5f89796031"

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
  
  # needed for icu4c/php-intl
  needs :cxx11

  resource "apcu" do
    url "http://pecl.php.net/get/apcu-5.1.11.tgz"
    sha256 "c1096c8c8d0dc75f902b68f699d10bc5056540ed15fb616414ccbfbedca8e95b"
  end

  resource "igbinary" do
    url "http://pecl.php.net/get/igbinary-2.0.5.tgz"
    sha256 "526b21f10b08eb9f6e17a6e92b6675348a5049e6d0f5a4ea0a38f24ec3513d34"
  end

  resource "imagick" do
    url "https://pecl.php.net/get/imagick-3.4.3.tgz"
    sha256 "1f3c5b5eeaa02800ad22f506cd100e8889a66b2ec937e192eaaa30d74562567c"
  end

  resource "memcached" do
    url "http://pecl.php.net/get/memcached-3.0.4.tgz"
    sha256 "561db4c8abdb7c344703a6b7b0ff4f29c2fe0fbacf7b2a2a704d0ed9b1a17d11"
  end

  resource "msgpack" do
    url "http://pecl.php.net/get/msgpack-2.0.2.tgz"
    sha256 "b04980df250214419d9c3d9a5cb2761047ddf5effe5bc1481a19fee209041c01"
  end

  resource "php-ast" do
    url "https://github.com/nikic/php-ast/archive/v0.1.6.tar.gz"
    sha256 "a6b8d13f0c2e5afa5a998f087e41bb912996a1dd5542def3beb85ea3eba61512"
  end

  resource "ssh2" do
    url "http://pecl.php.net/get/ssh2-1.1.1.tgz"
    sha256 "30963a0a4d9f704d594d875665c1ea297730a6efe2af22dff12a78183907ac0c"
  end

  resource "xdebug" do
    url "http://xdebug.org/files/xdebug-2.6.0.tgz"
    sha256 "b5264cc03bf68fcbb04b97229f96dca505d7b87ec2fb3bd4249896783d29cbdc"
  end

  resource "xdiff" do
    url "http://pecl.php.net/get/xdiff-2.0.1.tgz"
    sha256 "b4ac96c33ec28a5471b6498d18c84a6ad0fe2e4e890c93df08e34061fba7d207"
  end

  def config_path
    etc/"php/7.2/"
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
      "--with-pdo-pgsql=#{Formula["postgresql"].opt_prefix}",
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
      r.stage { (ext/r.name).install Dir["#{r.name}*/*"] } unless ["php-ast", "xdebug"].include?(r.name)
    end

    resource("php-ast").stage { (ext/"php-ast").install Dir["*"] }

    ENV.cxx11
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    rm "configure"
    system "./buildconf", "--force"

    system "./configure", *args

    system "make"
    system "make", "install"

    config_path.install "./php.ini-development" => "php.ini" unless File.exist? config_path + "/php.ini"
    config_path.install "sapi/fpm/php-fpm.conf" unless File.exist? config_path + "/php-fpm.conf"

    resource("xdebug").stage do |r|
      chdir "xdebug-#{r.version}" do
        system "phpize"
        system "./configure", *[
          "--prefix=#{prefix}",
          "--with-php-config=#{bin}/php-config",
          "--disable-debug",
          "--disable-dependency-tracking",
          "--enable-xdebug"
        ]
        system "make", "install"
      end
    end
  end

  plist_options :startup => true

  def plist; <<-EOS
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

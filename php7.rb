class Php7 < Formula
  desc "PHP is a popular general-purpose scripting language"
  homepage "http://php.net/"
  url "http://php.net/distributions/php-7.0.11.tar.gz"
  sha256 "02d27b5d140dbad8d400a95af808e1e9ce87aa8d2a2100870734ba26e6700d79"

  head "https://git.php.net/repository/php-src.git"

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "freetype"
  depends_on "gettext"
  depends_on 'gmp'
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

  # resource "igbinary" do
    # url ""
    # sha256 "8a0ad1812864764de52af04bbc112b739c3b5ca05e588093f44e8ea7d4074b42"
  # end

  resource "imagick" do
    url "https://pecl.php.net/get/imagick-3.4.3RC1.tgz"
    sha256 "50bbc46e78cd6e1ea5d7660be1722258e60b1729483ca14b02da7cf9f5ed3e6a"
  end

  resource "memcached" do
    url "https://github.com/php-memcached-dev/php-memcached/archive/583ecd68faec886ac9233277531f78fb6e2043c7.zip"
    sha256 "165c43b3d3b7d8da7df0ebbe0551d1a5ac6417e254ed2d86cb9d9b79815ecaf1"
  end

  resource "msgpack" do
    url "http://pecl.php.net/get/msgpack-2.0.1.tgz"
    sha256 "d32aeef9af3be6135a06f29e28ec9f386cde9d90ad346a396d9ba8018a7044c6"
  end

  resource "ssh2" do
    url "http://pecl.php.net/get/ssh2-1.0.tgz"
    sha256 "6a93891878b23904a773eb814fec7aea4ea00b4a412ee779c8535ed9c5e46ced"
  end

  resource "xdiff" do
    url "http://pecl.php.net/get/xdiff-2.0.1.tgz"
    sha256 "b4ac96c33ec28a5471b6498d18c84a6ad0fe2e4e890c93df08e34061fba7d207"
  end
  
  # resource "xhp" do
  #   url "https://github.com/phplang/xhp/archive/master.zip"
  #   sha256 "146b269d626422600ef75b9cf593dc0c215854dbf8f04466ec8d734eca497ebe"
  # end

  resource "xhprof" do
    url "https://github.com/RustJason/xhprof/archive/f6b73f72f919936c01f08de4f44af04a74fe4ffd.zip"
    sha256 "e139cbbeb3dbe4ca2683ad1f6b99f3bf9c465195d1b8587c128a8c4e08c3520d"
  end

  def config_path
    etc/"php7"
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
      # "--enable-igbinary",
      "--enable-intl",
      "--enable-mbstring",
      "--enable-memcached",
      # "--enable-memcached-igbinary",
      "--enable-memcached-json",
      "--enable-memcached-msgpack",
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
      
      "--with-bz2=#{MacOS.sdk_path}/usr",
      "--with-curl=#{Formula["curl"].prefix}",
      "--with-freetype-dir=#{Formula["freetype"].prefix}",
      "--with-gd",
      "--with-gettext=#{Formula["gettext"].prefix}",
      "--with-gmp",
      "--with-iconv-dir=/usr",
      "--with-imagick",
      "--with-jpeg-dir=#{Formula["jpeg"].prefix}",
      "--with-ldap=#{Formula["openldap"].prefix}",
      "--with-ldap-sasl=#{MacOS.sdk_path}/usr",
      "--with-libedit=#{MacOS.sdk_path}/usr",
      "--with-libxml-dir=#{Formula["libxml2"].prefix}",
      "--with-msgpack",
      "--with-mysql-sock=/tmp/mysql.sock",
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
      r.stage { (ext/r.name).install Dir["#{r.name}*/*"] } unless ["memcached", "xhprof"].include?(r.name)
    end
    
    resource("memcached").stage { (ext/"memcached").install Dir["*"] }
    resource("xhprof").stage { (ext/"xhprof").install Dir["xhprof*/extension/*"] }
    
    # resource("xhp").stage { (ext/"xhp").install Dir["*"] }

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

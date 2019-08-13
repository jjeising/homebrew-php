class PhpCustomAT73 < Formula
  desc "PHP is a popular general-purpose scripting language"
  homepage "http://php.net/"
  url "https://www.php.net/distributions/php-7.3.8.tar.bz2"
  sha256 "d566c630175d9fa84a98d3c9170ec033069e9e20c8d23dea49ae2a976b6c76f5"

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
  depends_on "msodbcsql17"
  depends_on "mysql"
  depends_on "net-snmp"
  depends_on "openldap"
  depends_on "openssl"
  depends_on "postgresql"
  depends_on "zeromq"
  
  # PHP build system incorrectly links system libraries
  # see https://github.com/php/php-src/pull/3472
  patch :DATA

  resource "apcu" do
    url "https://pecl.php.net/get/apcu-5.1.17.tgz"
    sha256 "6b11b477890a9c096ad856e0251920d1d8b9558b7d115256c027e0223755c793"
  end

  resource "igbinary" do
    url "https://pecl.php.net/get/igbinary-3.0.1.tgz"
    sha256 "5959607f3e236e19a9d01e1a8c74800fb3138f3528ba6601deedbd8b83ab12f1"
  end

  resource "imagick" do
    url "https://pecl.php.net/get/imagick-3.4.4.tgz"
    sha256 "8dd5aa16465c218651fc8993e1faecd982e6a597870fd4b937e9ece02d567077"
  end

  resource "memcached" do
    url "https://pecl.php.net/get/memcached-3.1.3.tgz"
    sha256 "20786213ff92cd7ebdb0d0ac10dde1e9580a2f84296618b666654fd76ea307d4"
  end

  resource "msgpack" do
    url "https://pecl.php.net/get/msgpack-2.0.3.tgz"
    sha256 "9dfa3c79d985334f82a88b7577f81d3ce4114211af064cffccf4d7b084a28842"
  end

  resource "php-ast" do
    url "https://github.com/nikic/php-ast/archive/v1.0.3.tar.gz"
    sha256 "3babb37876f5b6a7a65f340590b4478694cc8ea86c8cb524a503aa7960111f8a"
  end
  
  resource "pdo_sqlsrv" do
    url "https://pecl.php.net/get/pdo_sqlsrv-5.6.1.tgz"
    sha256 "caf4033677cc7b0992bd68ba1989a095e92150489efc98147445398763a0340a"
  end
  
  resource "sqlsrv" do
    url "https://pecl.php.net/get/sqlsrv-5.6.1.tgz"
    sha256 "0ab48ae7a9957586f5ec3ea1c19c528951517529078679a0dc3fd9fe83305445"
  end

  resource "ssh2" do
    # url "https://pecl.php.net/get/ssh2-1.1.2.tgz"
    url "https://git.php.net/repository/pecl/networking/ssh2.git"
    sha256 ""
  end

  resource "xdebug" do
    url "https://xdebug.org/files/xdebug-2.7.2.tgz"
    sha256 "b0f3283aa185c23fcd0137c3aaa58554d330995ef7a3421e983e8d018b05a4a6"
  end

  resource "xdiff" do
    url "https://pecl.php.net/get/xdiff-2.0.1.tgz"
    sha256 "b4ac96c33ec28a5471b6498d18c84a6ad0fe2e4e890c93df08e34061fba7d207"
  end
  
  resource "xmldiff" do
    url "https://pecl.php.net/get/xmldiff-1.1.2.tgz"
    sha256 "03b6c4831122e2d8cf97cb9890f8e2b6ac2106861c908d411025de6f07f7abb1"
  end

  def config_path
    etc/"php/7.3/"
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

      "--with-bz2=#{MacOS.sdk_path_if_needed}/usr",
      "--with-curl=#{Formula["curl"].opt_prefix}",
      "--with-freetype-dir=#{Formula["freetype"].opt_prefix}",
      "--with-gd",
      "--with-gettext=#{Formula["gettext"].opt_prefix}",
      "--with-gmp",
      "--with-iconv=#{MacOS.sdk_path_if_needed}/usr",
      "--with-imagick",
      "--with-jpeg-dir=#{Formula["jpeg"].opt_prefix}",
      "--with-ldap=#{Formula["openldap"].opt_prefix}",
      "--with-ldap-sasl=#{MacOS.sdk_path_if_needed}/usr",
      "--with-libedit=#{MacOS.sdk_path_if_needed}/usr",
      "--with-libxml-dir=#{Formula["libxml2"].opt_prefix}",
      "--with-msgpack",
      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysqli=mysqlnd",
      "--with-openssl=#{Formula["openssl"].opt_prefix}",
      "--with-pdo-mysql=mysqlnd",
      "--with-pdo-pgsql=#{Formula["postgresql"].opt_prefix}",
      "--with-pdo_sqlsrv",
      "--with-pear",
      "--with-png-dir=#{MacOS.sdk_path_if_needed}/usr",
      "--with-snmp=#{Formula["net-snmp"].opt_prefix}",
      "--with-ssh2",
      "--with-xdiff",
      # "--with-xmldiff",
      "--with-xmlrpc",
      "--with-xsl=#{Formula["libxslt"].opt_prefix}",
      "--with-zlib=#{MacOS.sdk_path_if_needed}/usr",
    ]

    ext = Pathname.new(pwd) + "ext/"

    resources.each do |r|
      r.stage { (ext/r.name).install Dir["#{r.name}*/*"] } unless ["php-ast", "ssh2", "xdebug", "xmldiff"].include?(r.name)
    end
    
    resource("ssh2").stage { (ext/"ssh2").install Dir["*"] }
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
        system "#{bin}/phpize"
        system "./configure", *[
          "--prefix=#{prefix}",
          "--with-php-config=#{bin}/php-config",
          "--enable-xdebug"
        ]
        system "make", "install"
      end
    end
    
    resource("xmldiff").stage do |r|
      chdir "xmldiff-#{r.version}" do
        system "#{bin}/phpize"
        system "./configure", *[
          "--prefix=#{prefix}",
          "--with-php-config=#{bin}/php-config",
          "--with-xmldiff"
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

__END__
diff --git a/acinclude.m4 b/acinclude.m4
index 168c465f8d..6c087d152f 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -441,7 +441,11 @@ dnl
 dnl Adds a path to linkpath/runpath (LDFLAGS)
 dnl
 AC_DEFUN([PHP_ADD_LIBPATH],[
-  if test "$1" != "/usr/$PHP_LIBDIR" && test "$1" != "/usr/lib"; then
+  case "$1" in
+  "/usr/$PHP_LIBDIR"|"/usr/lib"[)] ;;
+  /Library/Developer/CommandLineTools/SDKs/*/usr/lib[)] ;;
+  /Applications/Xcode*.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/*/usr/lib[)] ;;
+  *[)]
     PHP_EXPAND_PATH($1, ai_p)
     ifelse([$2],,[
       _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
@@ -452,8 +456,8 @@ AC_DEFUN([PHP_ADD_LIBPATH],[
       else
         _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
       fi
-    ])
-  fi
+    ]) ;;
+  esac
 ])

 dnl
@@ -487,7 +491,11 @@ dnl add an include path.
 dnl if before is 1, add in the beginning of INCLUDES.
 dnl
 AC_DEFUN([PHP_ADD_INCLUDE],[
-  if test "$1" != "/usr/include"; then
+  case "$1" in
+  "/usr/include"[)] ;;
+  /Library/Developer/CommandLineTools/SDKs/*/usr/include[)] ;;
+  /Applications/Xcode*.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/*/usr/include[)] ;;
+  *[)]
     PHP_EXPAND_PATH($1, ai_p)
     PHP_RUN_ONCE(INCLUDEPATH, $ai_p, [
       if test "$2"; then
@@ -495,8 +503,8 @@ AC_DEFUN([PHP_ADD_INCLUDE],[
       else
         INCLUDES="$INCLUDES -I$ai_p"
       fi
-    ])
-  fi
+    ]) ;;
+  esac
 ])

 dnl internal, don't use
@@ -2411,7 +2419,8 @@ AC_DEFUN([PHP_SETUP_ICONV], [
     fi

     if test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.a ||
-       test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.$SHLIB_SUFFIX_NAME
+       test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.$SHLIB_SUFFIX_NAME ||
+       test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.tbd
     then
       PHP_CHECK_LIBRARY($iconv_lib_name, libiconv, [
         found_iconv=yes

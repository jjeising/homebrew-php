require 'formula'

# via josegonzalez/homebrew-php
class Composer < Formula
  homepage 'http://getcomposer.org'
  url 'http://getcomposer.org/download/1.0.0-alpha7/composer.phar'
  sha1 '4f8513bea6daa4f70007e4344944c2fe458650ac'
  version '1.0.0-alpha7'
  
  def install
    libexec.install "composer.phar"
    sh = libexec + "composer"
    sh.write("#!/usr/bin/env bash\n\n/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/composer.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end
end
require 'formula'

# via josegonzalez/homebrew-php
class Composer < Formula
  homepage 'http://getcomposer.org'
  url 'http://getcomposer.org/download/1.0.0-alpha8/composer.phar'
  sha1 '6eefa41101a2d1a424c3d231a1f202dfe6f09cf8'
  version '1.0.0-alpha8'
  
  def install
    libexec.install "composer.phar"
    sh = libexec + "composer"
    sh.write("#!/usr/bin/env bash\n\n/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/composer.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end
end
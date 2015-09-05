require 'formula'

# via josegonzalez/homebrew-php
class Composer < Formula
  homepage 'http://getcomposer.org'
  url 'http://getcomposer.org/download/1.0.0-alpha10/composer.phar'
  sha256 '9f2c7d0364bc743bcde9cfe1fe84749e5ac38c46d47cf42966ce499135fd4628'
  version '1.0.0-alpha10'
  
  def install
    libexec.install "composer.phar"
    sh = libexec + "composer"
    sh.write("#!/usr/bin/env bash\n\n/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/composer.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end
end
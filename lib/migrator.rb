require 'java'

require 'rubygems'
require 'dbi'
require 'dbd/Jdbc'
require 'jdbc/mysql'
require 'json'
require 'csv'
require 'redis'
require 'unicode'
require_relative 'migrator/config'
require_relative 'migrator/dumper'
require_relative 'gnparser-assembly-0.4.1.jar'

java_import 'org.globalnames.parser.ScientificNameParser'
java_import 'org.globalnames.UuidGenerator'

# Migrates data from GNI to GNINDEX
module Migrator
  class << self
    def run(opts)
      puts opts
      gni_dumper = Dumper.new
      gni_dumper.run
    end
  end
end

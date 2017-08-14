module Migrator
  # Dumps data from mysql to csv files
  class Dump
    def initialize
      @db = Mysql2::Client.new(:host => Conf.mysql_host, :username => Conf.username)
    end
  end
end

module Migrator
  # Dumps data from mysql to csv files
  class Dumper
    def initialize
      @snp = ScientificNameParser.instance
      gni = Conf[:gni]
      Jdbc::MySQL.load_driver
      @db = DBI.connect(
        "DBI:Jdbc:mysql://#{gni[:host]}/#{gni[:database]}",
        gni[:username], gni[:password],
        'driver' => 'com.mysql.jdbc.Driver')

    end

    def run

      name_string_file = File.expand_path(File.join(__dir__, '..',
                                          '..', 'csv', 'name_strings.csv'))
      @name_strings = CSV.open(name_string_file, "w:utf-8")
      @name_strings << %w[id name canonical_uuid canonical surrogate]

      authors_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__author_words.csv'))
      @author = CSV.open(authors_file, "w:utf-8")
      @author << %w[author_word name_uuid]

      genus_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__genus.csv'))
      @genus = CSV.open(genus_file, "w:utf-8")
      @genus << %w[genus name_uuid]


      species_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__species.csv'))
      @species = CSV.open(species_file, "w:utf-8")
      @species << %w[species name_uuid]

      subspecies_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__subspecies.csv'))
      @subspecies = CSV.open(subspecies_file, "w:utf-8")
      @subspecies << %w[subspecies name_uuid]

      uninomial_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__uninomial.csv'))
      @uninomial = CSV.open(subspecies_file, "w:utf-8")
      @uninomial << %w[uninomial name_uuid]

      year_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__year.csv'))
      @year = CSV.open(subspecies_file, "w:utf-8")
      @year << %w[year name_uuid]

      offset = 0
      limit = 100000
      while offset < 25_000_000
        puts "Rows so far: #{offset}"
        res = @db.execute "SELECT name, surrogate
                           FROM name_strings
                           limit #{limit} offset #{offset}"
        offset += limit
        while row = res.fetch do
          entry = prepare_entry(row)
          @name_strings << entry
        end
        res.finish
      end
    end

    def prepare_entry(row)
      name = row[0]
      surrogate = row[1]
      parsed = JSON.parse(@snp.fromString(name).renderCompactJson,
                          symbolize_names: true)
      id = parsed[:name_string_id]
      canonical = canonical_uuid = nil
      if parsed[:parsed]
        add_words(parsed[:positions], id, name)
        canonical = parsed[:canonical_name][:value]
        parsed_canonical = JSON.parse(
          @snp.fromString(canonical).renderCompactJson,
          symbolize_names: true)
        canonical_uuid = parsed_canonical[:name_string_id]
      end
      [id, name, canonical_uuid, canonical, surrogate]
    end

    def add_words(pos, id, name)
      pos.each do |e|
        word = name[e[1]...e[2]]
        entry = [word, id]
        case e[0]
        when 'uninomial'
          @uninomial << entry
        when 'genus'
          @genus << entry
        when 'specific_epithet'
          @species << entry
        when 'subspecific_epithet'
          @subspecies << entry
        when 'author_word'
          @author << entry
        when 'year'
          @year << entry
        end
      end
    end
# {"name_string_id":"b0f8459f-8b73-514c-b6f3-568d54d99ded","parsed":true,"quality":1,"parser_version":"0.4.1","verbatim":"Salinator
# so lida (Martens, 1878)","normalized":"Salinator solida (Martens
# 1878)","canonical_name":{"value":"Salinator solida"},"hybrid":false,"s
# urrogate":false,"virus":false,"bacteria":false,"details":[{"genus":{"value":"Salinator"},"specific_epithet":{"value":"solida","autho
#  rship":{"value":"(Martens
#                    1878)","basionym_authorship":{"authors":["Martens"],"year":{"value":"1878"}}}}}],"positions":[["genus",0,9
# ],["specific_epithet",10,16],["author_word",18,25],["year",27,31]]}
# """
  end
end

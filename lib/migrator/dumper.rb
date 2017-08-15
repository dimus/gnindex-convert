module Migrator
  # Dumps data from mysql to csv files
  class Dumper
    def initialize
      @snp = ScientificNameParser.instance
      @redis = Redis.new
      gni = Conf[:gni]
      Jdbc::MySQL.load_driver
      @db = DBI.connect(
        "DBI:Jdbc:mysql://#{gni[:host]}/#{gni[:database]}",
        gni[:username], gni[:password],
        'driver' => 'com.mysql.jdbc.Driver')
      prepare_csv
    end

    def run
      prepare_data_sources
      prepare_name_strings
      prepare_name_string_indices
      prepare_vernacular_strings
      prepare_vernacular_string_indices
    end

    def processing_title(table)
      puts
      puts "*" * 50
      puts "Processing #{table}"
      puts "*" * 50
      puts
    end

    def prepare_data_sources
      res = @db.execute "SELECT id, title, description,
                          logo_url, web_site_url, data_url,
                          refresh_period_days, name_strings_count,
                          data_hash, unique_names_count, created_at,
                          updated_at
                          FROM data_sources"
      while row = res.fetch do
        entry = entry_data_source(row)
        @data_sources << entry
      end
      res.finish
    end

    def entry_data_source(row)
      [row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7],
       row[8], row[9], row[10], row[11]]
    end

    def prepare_name_strings
      processing_title("name_strings and Co")
      offset = 0
      limit = 10000
      while offset < 10_000 # 26_000_000
        puts "name_strings rows so far: #{offset}"
        res = @db.execute "SELECT name, surrogate, id
                           FROM name_strings
                           limit #{limit} offset #{offset}"
        offset += limit
        while row = res.fetch do
          entry = entry_name_strings(row)
          @name_strings << entry
        end
        res.finish
      end
    end

    def entry_name_strings(row)
      name = row[0]
      surrogate = row[1]
      parsed = JSON.parse(@snp.fromString(name).renderCompactJson,
                          symbolize_names: true)
      id = parsed[:name_string_id]
      canonical = canonical_uuid = nil
      if parsed[:parsed]
        add_words(parsed[:positions], id, name)
        canonical = parsed[:canonical_name][:value]
        canonical_uuid = UuidGenerator.generate(canonical)
      end
      @redis.set("ns:" + row[2], id)
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

    def prepare_name_string_indices
      processing_title("name_string_indices")
      offset = 0
      limit = 10000
      while offset < 10_000 # 51_200_000
        puts "name_string_indices rows so far: #{offset}"
        res = @db.execute "SELECT data_source_id, name_string_id,
                           url, taxon_id, global_id, local_id,
                           nomenclatural_code_id, rank,
                           accepted_taxon_id, classification_path,
                           classification_path_ids,
                           classification_path_ranks
                           FROM name_string_indices
                           limit #{limit} offset #{offset}"
        offset += limit
        while row = res.fetch do
          entry = entry_name_string_indices(row)
          @name_string_indices << entry
        end
        res.finish
      end
    end

    def entry_name_string_indices(row)
      [row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8],
       row[9], row[10], row[11], nil, nil]
    end

    def prepare_vernacular_strings
      processing_title("vernacular_strings")
      offset = 0
      limit = 100_000
      while offset < 1_200_000
        puts "vernacular_strings rows so far: #{offset}"
        res = @db.execute "SELECT id, name
                           FROM vernacular_strings
                           limit #{limit} offset #{offset}"
        offset += limit
        while row = res.fetch do
          entry = entry_vernacular(row)
          @vernacular_strings << entry
        end
        res.finish
      end
    end

    def entry_vernacular(row)
      uuid = UuidGenerator.generate(row[1])
      @redis.set("vn:" + row[0], uuid)
      [uuid, row[1]]
    end

    def prepare_vernacular_string_indices
      processing_title("vernacular_string_indices")
      offset = 0
      limit = 100_000
      while offset < 2_500_000
        puts "vernacular_strings_indices rows so far: #{offset}"
        res = @db.execute "SELECT data_source_id, taxon_id,
                           vernacular_string_id, language, locality,
                           country_code
                           FROM vernacular_string_indices
                           limit #{limit} offset #{offset}"
        offset += limit
        while row = res.fetch do
          entry = entry_vernacular_indices(row)
          @vernacular_string_indices << entry
        end
        res.finish
      end
    end

    def entry_vernacular_indices(row)
      uuid = @redis.get("vn:" + row[2])
      [row[0], row[1], uuid, row[3], row[4], row[5]]
    end

    private

    def prepare_csv
      data_source_file = File.expand_path(File.join(__dir__, '..',
                                          '..', 'csv', 'data_sources.csv'))

      @data_sources = CSV.open(data_source_file, "w:utf-8")
      @data_sources << %w[id title description
                          logo_url web_site_url data_url
                          refresh_period_days name_strings_count
                          data_hash unique_names_count created_at
                          updated_at]

      name_string_file = File.expand_path(File.join(__dir__, '..',
                                          '..', 'csv', 'name_strings.csv'))
      @name_strings = CSV.open(name_string_file, "w:utf-8")
      @name_strings << %w[id name canonical_uuid canonical surrogate]

      name_string_indices_file = File.expand_path(File.join(__dir__, '..',
                                          '..', 'csv',
                                          'name_string_indices.csv'))
      @name_string_indices = CSV.open(name_string_indices_file, "w:utf-8")
      @name_string_indices << %w[data_source_id name_string_id
                                 url taxon_id global_id local_id
                                 nomenclatural_code_id rank
                                 accepted_taxon_id classification_path
                                 classification_path_ids
                                 classification_path_ranks accepted_name_uuid
                                 accepted_name]

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
      @uninomial = CSV.open(uninomial_file, "w:utf-8")
      @uninomial << %w[uninomial name_uuid]

      year_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'name_strings__year.csv'))
      @year = CSV.open(year_file, "w:utf-8")
      @year << %w[year name_uuid]

      vernacular_strings_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'vernacular_strings.csv'))
      @vernacular_strings = CSV.open(vernacular_strings_file, "w:utf-8")
      @vernacular_strings << %w[id name]

      vernacular_string_indices_file = File.expand_path(File.join(__dir__, '..',
                                      '..', 'csv',
                                      'vernacular_string_indices.csv'))
      @vernacular_string_indices = CSV.open(vernacular_string_indices_file,
                                            "w:utf-8")
      @vernacular_string_indices << %w[data_source_id taxon_id
                                       vernacular_string_id language
                                       locality country_code]

    end
  end
end

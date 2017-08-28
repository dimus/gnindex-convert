# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity

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
        'driver' => 'com.mysql.jdbc.Driver'
      )
    end

    def run
      # prepare_data_sources
      # prepare_name_strings
      prepare_name_string_indices
      revisit_name_string_indices
      prepare_vernacular_strings
      prepare_vernacular_string_indices
    end

    def processing_title(table)
      puts
      puts '*' * 50
      puts "Processing #{table}"
      puts '*' * 50
      puts
    end

    def revisit_name_string_indices_title
      puts
      puts '*' * 50
      puts 'Adding fields to name_string_indices'
      puts '*' * 50
      puts
    end

    def prepare_data_sources
      processing_title("data_sources")
      init_data_sources
      res = @db.execute "SELECT id, title, description,
                           logo_url, web_site_url, data_url,
                           refresh_period_days, name_strings_count,
                           data_hash, unique_names_count, created_at,
                           updated_at
                         FROM data_sources"
      until (row = res.fetch).nil?
        entry = entry_data_source(row)
        @data_sources << entry
      end
      res.finish
      @data_sources.close
    end

    def entry_data_source(row)
      [row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7],
       row[8], row[9], row[10], row[11]]
    end

    def prepare_name_strings
      processing_title('name_strings and Co')
      init_name_strings
      init_name_strings__author_words
      init_name_strings__genus
      init_name_strings__species
      init_name_strings__subspecies
      init_name_strings__uninomial
      init_name_strings__year
      offset = 0
      limit = 100_000
      loop do
        puts "name_strings rows so far: #{offset}"
        res = @db.execute "SELECT name, id
                           FROM name_strings
                           limit #{limit} offset #{offset}"
        break if res.fetch.nil?
        offset += limit
        until (row = res.fetch).nil?
          entry = entry_name_strings(row)
          @name_strings << entry
        end
        res.finish
      end
      @name_strings.close
      @uninomial.close
      @genus.close
      @species.close
      @subspecies.close
      @author.close
      @year.close
    end

    def entry_name_strings(row)
      name = row[0]
      parsed = JSON.parse(@snp.fromString(name).renderCompactJson,
                          symbolize_names: true)
      id = parsed[:name_string_id]
      canonical = canonical_uuid = nil
      surrogate = false
      if parsed[:parsed]
        add_words(parsed[:positions], id, name)
        canonical = parsed[:canonical_name][:value]
        surrogate = parsed[:surrogate]
        canonical_uuid = UuidGenerator.generate(canonical)
      end
      @redis.set('ns:' + row[1], id)
      @redis.set('uu:' + id, name)
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
        when 'infraspecific_epithet'
          @subspecies << entry
        when 'author_word'
          @author << entry
        when 'year'
          @year << entry
        end
      end
    end

    def prepare_name_string_indices
      init_name_string_indices_tmp
      processing_title('name_string_indices')
      offset = 0
      limit = 100_000
      loop do
        puts "name_string_indices rows so far: #{offset}"
        res = @db.execute "SELECT data_source_id, name_string_id,
                           url, taxon_id, global_id, local_id,
                           nomenclatural_code_id, rank,
                           accepted_taxon_id, classification_path,
                           classification_path_ids,
                           classification_path_ranks
                           FROM name_string_indices
                           limit #{limit} offset #{offset}"
        break if res.fetch.nil?
        offset += limit
        until (row = res.fetch).nil?
          entry = entry_name_string_indices(row)
          @name_string_indices_tmp << entry
        end
        res.finish
      end
      @name_string_indices_tmp.close
    end

    def revisit_name_string_indices
      revisit_name_string_indices_title
      @name_string_indices_tmp = CSV.open(name_string_indices_tmp_file)
      init_name_string_indices
      @name_string_indices_tmp.each_with_index do |row, i|
        if i.zero?
          @name_string_indices << row
        else
          puts "Row for name_string_indices #{i}" if (i % 100_000).zero?
          data_source_id = row[0]
          accepted_taxon_id = row[8].to_s.strip == "" ? nil : row[8]
          accepted_name_uuid = @redis.get(
            "i:#{data_source_id}-#{accepted_taxon_id}"
          ) rescue nil
          accepted_name =
            @redis.get('uu:' + accepted_name_uuid) rescue nil
          row = row[0...-2] + [accepted_name_uuid, accepted_name]
          row[8] = accepted_taxon_id
          @name_string_indices << row
        end
      end
      @name_string_indices.close
      @name_string_indices_tmp.close
    end

    def entry_name_string_indices(row)
      uuid = @redis.get('ns:' + row[1])
      @redis.set("i:#{row[0]}-#{row[3]}", uuid)
      [row[0], uuid, row[2], row[3], row[4], row[5], row[6], row[7], row[8],
       row[9], row[10], row[11], nil, nil]
    end

    def prepare_vernacular_strings
      processing_title('vernacular_strings')
      init_vernacular_strings
      offset = 0
      limit = 100_000
      loop do
        puts "vernacular_strings rows so far: #{offset}"
        res = @db.execute "SELECT id, name
                           FROM vernacular_strings
                           limit #{limit} offset #{offset}"
        break if res.fetch.nil?
        offset += limit
        until (row = res.fetch).nil?
          entry = entry_vernacular(row)
          @vernacular_strings << entry
        end
        res.finish
      end
      @vernacular_strings.close
    end

    def entry_vernacular(row)
      uuid = UuidGenerator.generate(row[1])
      @redis.set('vn:' + row[0], uuid)
      [uuid, row[1]]
    end

    def prepare_vernacular_string_indices
      processing_title('vernacular_string_indices')
      init_vernacular_string_indices
      offset = 0
      limit = 100_000
      loop do
        puts "vernacular_strings_indices rows so far: #{offset}"
        res = @db.execute "SELECT data_source_id, taxon_id,
                           vernacular_string_id, language, locality,
                           country_code
                           FROM vernacular_string_indices
                           limit #{limit} offset #{offset}"
        break if res.fetch.nil?
        offset += limit
        until (row = res.fetch).nil?
          entry = entry_vernacular_indices(row)
          @vernacular_string_indices << entry
        end
        res.finish
      end
      @vernacular_string_indices.close
    end

    def entry_vernacular_indices(row)
      uuid = @redis.get('vn:' + row[2])
      [row[0], row[1], uuid, row[3], row[4], row[5]]
    end

    private

    def init_data_sources
      data_source_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'data_sources.csv')
      )
      @data_sources = CSV.open(data_source_file, 'w:utf-8')
      @data_sources << %w[id title description
                          logo_url web_site_url data_url
                          refresh_period_days name_strings_count
                          data_hash unique_names_count created_at
                          updated_at]
    end

    def init_name_strings
      name_string_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_strings.csv')
      )
      @name_strings = CSV.open(name_string_file, 'w:utf-8')
      @name_strings << %w[id name canonical_uuid canonical surrogate]
    end

    def name_string_indices_tmp_file
      File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_string_indices_tmp.csv')
      )
    end

    def init_name_string_indices_tmp
      @name_string_indices_tmp = CSV.open(name_string_indices_tmp_file,
                                          'w:utf-8')
      @name_string_indices_tmp << %w[data_source_id name_string_id
                                     url taxon_id global_id local_id
                                     nomenclatural_code_id rank
                                     accepted_taxon_id classification_path
                                     classification_path_ids
                                     classification_path_ranks
                                     accepted_name_uuid accepted_name]
    end

    def init_name_string_indices
      name_string_indices_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_string_indices.csv')
      )
      @name_string_indices = CSV.open(name_string_indices_file, 'w:utf-8')
    end

    def init_name_strings__author_words
      authors_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv',
                  'name_strings__author_words.csv')
      )
      @author = CSV.open(authors_file, 'w:utf-8')
      @author << %w[author_word name_uuid]
    end

    def init_name_strings__genus
      genus_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_strings__genus.csv')
      )
      @genus = CSV.open(genus_file, 'w:utf-8')
      @genus << %w[genus name_uuid]
    end

    def init_name_strings__species
      species_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_strings__species.csv')
      )
      @species = CSV.open(species_file, 'w:utf-8')
      @species << %w[species name_uuid]
    end

    def init_name_strings__subspecies
      subspecies_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_strings__subspecies.csv')
      )
      @subspecies = CSV.open(subspecies_file, 'w:utf-8')
      @subspecies << %w[subspecies name_uuid]
    end

    def init_name_strings__uninomial
      uninomial_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_strings__uninomial.csv')
      )
      @uninomial = CSV.open(uninomial_file, 'w:utf-8')
      @uninomial << %w[uninomial name_uuid]
    end

    def init_name_strings__year
      year_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'name_strings__year.csv')
      )
      @year = CSV.open(year_file, 'w:utf-8')
      @year << %w[year name_uuid]
    end

    def init_vernacular_strings
      vernacular_strings_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'vernacular_strings.csv')
      )
      @vernacular_strings = CSV.open(vernacular_strings_file, 'w:utf-8')
      @vernacular_strings << %w[id name]
    end

    def init_vernacular_string_indices
      vernacular_string_indices_file = File.expand_path(
        File.join(__dir__, '..', '..', 'csv', 'vernacular_string_indices.csv')
      )
      @vernacular_string_indices = CSV.open(vernacular_string_indices_file,
                                            'w:utf-8')
      @vernacular_string_indices << %w[data_source_id taxon_id
                                       vernacular_string_id language
                                       locality country_code]
    end
  end
end

# rubocop:enable all

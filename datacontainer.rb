# Author:: Robert Uhl (mailto:uhlrc@yahoo.com)
# License:: GPL V2
# Copyright:: (C) 2013  Robert Uhl

#--
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#++

require 'sqlite3'
require 'yaml'

#Data wrapper for managing the sqlite db and yml flat files we generate it from.

class DataContainer

  def initialize(logger)
    @log = logger
    @dbfilename = "pcu.db"  
    @db = SQLite3::Database.new(@dbfilename)    
  end
  
  def create
    @log.info "creating new db"
    if File.exists?(@dbfilename) then
      @db.close
      @log.info "deleting old db"
      File.delete(@dbfilename)
    end
    @db = SQLite3::Database.new(@dbfilename)
    
    file_path = "dbsources/"
    
    Dir.foreach(file_path) do |file|
      next if file == '.' or file ==  '..'
      create_table_from_file( file, file_path )
    end
  end
  
  def create_table_from_file( file, path )
    @log.info {"creating table from #{file}"}
    
    table_name = file.split(".")[0]   
    
    raw_table = YAML.load_file( path + file )
    query = raw_table["tablequery"]
    @log.debug {"running: #{query}"}
    @db.execute(query)
    raw_table[table_name].each do |row|
      row_query = "INSERT INTO tbl#{table_name} (#{row.keys.join(",")}) VALUES (:#{row.keys.join(",:")})"
      encode_arrays row
      @log.debug {"running: #{row_query} with \n #{row.inspect}"}
      @db.execute(row_query, row)    
    end    
  end
  
  def encode_arrays(row)
    row.keys.each do |item|
      if row[item].is_a? Array or row[item].is_a? Hash
        row[item] = row[item].to_yaml
      end
    end
  end
  
  # Returns alignments [name, abbrev, id]
  
  def get_alignments
    if @alignments.nil?
      @alignments = @db.execute( "Select name, abbrev, id from tblalignments")
    end
    return @alignments
  end
  
  # Returns pointbuys [type, id] 
  
  def get_pointbuys
    if @pointbuys.nil?
      @pointbuys = @db.execute( "Select type, id from tblpointbuys" )
    end
    return @pointbuys    
  end
  
  def get_attributes
    if @attribute_hashes.nil?
      @attribute_hashes = []
      cols = nil
      @db.execute2( "Select name, abbrev, id from tblattributes" ) do |row|
        if cols.nil?
          cols = row
        else
          hash = {}
          cols.each_with_index { |item, index| hash[item] = row[index] }
          @attribute_hashes << hash
        end
      end
    end
    @log.debug {"returning attribute info: #{@attribute_hashes}"}
    return @attribute_hashes    
  end
  
  # Returns genders [name, abbrev, id]
  
  def get_genders
    if @genders.nil?
      @genders = @db.execute( "Select name, abbrev, id from tblgenders" )
    end
    return @genders    
  end
  
  # Returns class hash
  
  def get_classes
    if @class_hash.nil?
      classes = @db.execute ("Select name, hitdie, skills from tblclasses")
      @class_hash = {}
      classes.each do |class_row|
        @class_hash[class_row[0]] = {name:class_row[0], hitdie:class_row[1], skills:class_row[2]}
      end      
    end
    return @class_hash
  end
  
  # Returns races [name, id ]
  
  def get_races
    if @races.nil?
      @races = @db.execute( "Select name, id from tblraces" )
    end
    return @races
  end
  
  # returns a hash of race stat options keyed on race name.
  
  def get_race_stats
    if @race_stat_hash.nil?
      race_stats = @db.execute ("Select name, str, dex, con, int, wis, cha, optional from tblraces r join tblraceabilityscores rsa on r.id = rsa.raceid")
      @race_stat_hash = {}
      race_stats.each do |race_row|
        @race_stat_hash[race_row[0]] = {name:race_row[0], stats_array:race_row[1..-2], optional:race_row.last }
      end      
    end
    return @race_stat_hash
  end
  
  def get_race_alt_traits (race_id)
    @race_alt_traits = {} if @race_alt_traits.nil?
    if @race_alt_traits[race_id].nil?
      @race_alt_traits[race_id] = get_race_traits(race_id, 0)
    end
    return @race_alt_traits[race_id].clone
  end
  
  def get_all_race_traits(race_id)
    @race_traits = {} if @race_traits.nil?
    if @race_traits[race_id].nil?
      @race_traits[race_id] = get_race_traits(race_id, nil)
    end
    return @race_traits[race_id].clone
  end
  
  def get_base_race_traits (race_id)
    @race_base_traits = {} if @race_base_traits.nil?
    if @race_base_traits[race_id].nil?
      @race_base_traits[race_id] = get_race_traits(race_id, 1)
    end
    return @race_base_traits[race_id].clone
  end
  
  def get_race_traits(race_id, default)
    query = ""
    if default.nil?
      query = "Select name, description, effect, id, isdefault from tblracialtraits where raceid = '#{race_id}'"
    else
      query = "Select name, description, effect, id, isdefault from tblracialtraits where isdefault = '#{default}' and raceid = '#{race_id}'"
    end
    @log.debug {query}
    traits = @db.execute (query)      
    results = {}    
    traits.each do |trait_row|
      @log.debug {"adding row: #{trait_row}"}
      results[trait_row[0]] = {
        name:trait_row[0], 
        description:trait_row[1], 
        effect:YAML.load(trait_row[2]), 
        id:trait_row[3],
        isdefault:trait_row[4]
        }        
    end
    return results
  end
end
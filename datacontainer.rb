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
      @log.debug {"running: #{row_query}"}
      @db.execute(row_query, row)    
    end    
  end
  
  def encode_arrays(row)
    row.keys.each do |item|
      if row[item].is_a? Array
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
  
  # Returns genders [name, abbrev, id]
  
  def get_genders
    if @genders.nil?
      @genders = @db.execute( "Select name, abbrev, id from tblgenders" )
    end
    return @genders    
  end
  
  # Returns races [name, id ]
  
  def get_races
    if @races.nil?
      @races = @db.execute( "Select name, id from tblraces" )
    end
    return @races
  end
  
  def get_race_stats
    if @race_stat_hash.nil?
      race_stats = @db.execute ("Select name, str, dex, con, int, wis, cha, optional from tblraces r join tblraceabilityscores rsa on r.id = rsa.raceid")
      @race_stat_hash = {}
      race_stats.each do |race_row|
        @race_stat_hash[race_row[0]] = race_row[1..-2]
      end      
    end
    return @race_stat_hash
  end
end
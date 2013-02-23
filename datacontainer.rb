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
      @log.debug {"running: #{row_query}"}
      @db.execute(row_query, row)    
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
end
# Default values
ENV_HASH = {"PORT"=>3000,"DATABASE_PATH"=>Dir.current + "/db/pass.db","KEY"=>"","IV"=>""}

# Check .env
if File.file?(".env")
  File.each_line(".env") do |line|
    line = line.gsub('"', "")

    key = line.split("=")[0]
    val = line.split("=")[1]

    if key == "PORT"
      ENV_HASH["PORT"] = val
    end
    if key == "DATABASE_PATH"
      ENV_HASH["DATABASE_PATH"] = val
    end
    if key == "KEY"
      ENV_HASH["KEY"] = val
    end
    if key == "IV"
      ENV_HASH["IV"] = val
    end
  end
else
  Log.warn { ".env file is missing." }
  exit
end

module Model
  module ConnDB
    extend Crecto::Repo
    config do |conf|
      conf.adapter = Crecto::Adapters::SQLite3
      conf.database = ENV_HASH["DATABASE_PATH"].to_s
    end
  end

  class Data < Crecto::Model
    schema "data" do # table name
      field :id, Int32, primary_key: true
      field :name, String
      field :username, String
      field :password, String
      field :tag, String
    end
    validate_required [:name, :username, :password]
  end
end

module Controller
  module Data
    extend self

    Query = Crecto::Repo::Query

    def all()
      key = ENV_HASH["KEY"].to_s
      iv  = ENV_HASH["IV"].to_s

      records = Model::ConnDB.all(Model::Data)
      records.each do |record|
        record.password = Pass::Secure.decrypt(record.password.to_s.hexbytes,key,iv)
      end
      records
    end

    def search_id(id)
      key = ENV_HASH["KEY"].to_s
      iv  = ENV_HASH["IV"].to_s

      records = Model::ConnDB.all(Model::Data, Query.where(id: id))
      records.each do |record|
        record.password = Pass::Secure.decrypt(record.password.to_s.hexbytes,key,iv)
      end
      records
    end

    def search_name(name)
      key = ENV_HASH["KEY"].to_s
      iv  = ENV_HASH["IV"].to_s

      records = Model::ConnDB.all(Model::Data, Query.where(name: name))
      records.each do |record|
        record.password = Pass::Secure.decrypt(record.password.to_s.hexbytes,key,iv)
      end
      records
    end

    def search_username(username)
      Model::ConnDB.all(Model::Data, Query.where(username: username))
    end

    def search_tag(tag)
      Model::ConnDB.all(Model::Data, Query.where(tag: tag))
    end

    def search_name_username(name,username)
      Model::ConnDB.all(Model::Data, Query.where(name: name, username: username))
    end

    def create(name,username,password,tag)
      key = ENV_HASH["KEY"].to_s
      iv  = ENV_HASH["IV"].to_s

      data_record = Model::Data.new
      data_record.name     = name
      data_record.username = username
      data_record.password = Pass::Secure.encrypt(password,key,iv).hexstring
      data_record.tag      = tag
      changeset = Model::ConnDB.insert(data_record)

      data_id = changeset.instance.id

      {id: data_id, status: "OK",message: "Record was created."}
    end

    def update(id,name,username,password,tag)
      key = ENV_HASH["KEY"].to_s
      iv  = ENV_HASH["IV"].to_s

      data_record = Model::ConnDB.get!(Model::Data, id)
      data_record.name     = name if name.size > 0
      data_record.username = username if username.size > 0
      data_record.password = Pass::Secure.encrypt(password,key,iv).hexstring if password.size > 0
      data_record.tag      = tag if tag.size > 0
      
      changeset = Model::ConnDB.update(data_record)

      {id: id, status: "OK",message: "Record was updated."}
    end

    def remove(id)
      data_record = Model::ConnDB.get!(Model::Data, id)
      Model::ConnDB.delete(data_record)

      {id: id, status: "OK",message: "Record was removed."}
    end

  end
end

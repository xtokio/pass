# TODO: Write documentation for `Pass`
require "option_parser"
require "random/secure"
require "openssl"
require "colorize"
require "sqlite3"
require "crecto"
require "./base/*"

param_add    = false
param_update = false
param_remove = false
param_search = false
param_all    = false
param_id       = ""
param_name     = ""
param_username = ""
param_password = ""
param_tag      = ""

module Pass
  VERSION = "0.1.0"

  # TODO: Put your code here

  # Parameters
  OptionParser.parse do |parser|
    parser.banner = "Password Store"

    parser.on "--version", "Show version" do
      puts "version 1.0"
      exit
    end
    
    parser.on "--help", "Show help" do
      puts parser
      exit
    end

    parser.on "--key_pair", "Generates Key pair for key and iv" do
      key = Random::Secure.hex(32)
      iv  = Random::Secure.hex(32)
      
      puts "Key: ".colorize(:green).to_s + key
      puts "IV : ".colorize(:green).to_s + iv
      exit
    end

    parser.on "--random", "Generates Random Key" do
      puts Random::Secure.hex(32)
      exit
    end

    parser.on "--add", "Add a new record" do
      param_add = true
    end

    parser.on "--update", "Updates a record" do
      param_update = true
    end

    parser.on "--remove", "Removes a record" do
      param_remove = true
    end

    parser.on "--search", "Search a record" do
      param_search = true
    end

    parser.on "--all", "Displays all records" do
      param_all = true
    end

    parser.on "--id=ID", "Sets id" do |input_option|
      param_id = input_option
    end

    parser.on "--name=NAME", "Sets name" do |input_option|
      param_name = input_option
    end

    parser.on "--username=USERNAME", "Sets Username" do |input_option|
      param_username = input_option
    end

    parser.on "--password=PASSWORD", "Sets Password" do |input_option|
      param_password = input_option
    end

    parser.on "--tag=TAG", "Sets Tag" do |input_option|
      param_tag = input_option
    end

    parser.invalid_option do |flag|
      STDERR.puts "ERROR: ".colorize(:red).to_s + flag.colorize(:green).underline.to_s + " is not a valid option."
      STDERR.puts
      STDERR.puts parser
      exit(1)
    end

  end

  # ./pass --add --name=Email --username=xtokio@gmail.com --password=123ABC --tag=Google
  if param_add
    if param_name.size > 0
      if param_username.size > 0
        if param_password.size > 0
          response = Controller::Data.create(param_name,param_username,param_password,param_tag)
          puts response.to_json
        end
      end
    end
  end

  # ./pass --update --id=1 --name=Email --username=xtokio@gmail.com --password=123ABC --tag=Google
  if param_update
    if param_id.size > 0
      response = Controller::Data.update(param_id,param_name,param_username,param_password,param_tag)
      puts response.to_json
    end
  end

  # ./pass --remove --id=1
  if param_remove
    if param_id.size > 0
      response = Controller::Data.remove(param_id)
      puts response.to_json
    end
  end

  # ./pass --search --all | jq '.'
  # ./pass --search --name=Email | jq '.[] | .password'
  if param_search
    if param_all
      response = Controller::Data.all()
      puts response.to_json
    elsif param_id.size > 0
      response = Controller::Data.search_id(param_id)
      puts response.to_json
    elsif param_name.size > 0
      response = Controller::Data.search_name(param_name)
      puts response.to_json
    elsif param_username.size > 0
      response = Controller::Data.search_username(param_username)
      puts response.to_json
    elsif param_tag.size > 0
      response = Controller::Data.search_tag(param_tag)
      puts response.to_json
    end
  end

end

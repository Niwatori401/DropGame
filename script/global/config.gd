extends Node

const CONFIG_FILE_LOCATION = "user://config.cfg";
var config_file = ConfigFile.new();

const SECTION_ACCOUNT := "account";
const KEY_USEACCOUNT := "useAccount";
const KEY_USERNAME := "username";
const KEY_PASSWORD := "password";

const SECTION_APPLICATION := "application";
const KEY_BASEURL := "baseUrl";
const KEY_VERSION := "version";

const VERSION := "1.0";

const DEFAULT_URL := "http://niwatori.party:2369";

func _ready():
	var err = config_file.load(CONFIG_FILE_LOCATION);
	if err != OK:
		print("Didn't find config file, generating new one.");
		config_file = ConfigFile.new();
		config_file.save(CONFIG_FILE_LOCATION);
	
	var version = config_file.get_value(SECTION_ACCOUNT, KEY_VERSION, "undefined");
	if version != Config.VERSION:
		if config_file.has_section(Config.SECTION_APPLICATION):
			config_file.erase_section(Config.SECTION_APPLICATION);
		
		config_file.set_value(Config.SECTION_APPLICATION, Config.KEY_VERSION, Config.VERSION);
		commit_changes();
	
	var base_url = config_file.get_value(Config.SECTION_APPLICATION, Config.KEY_BASEURL, "");
	if base_url == "":
		config_file.set_value(Config.SECTION_APPLICATION, Config.KEY_BASEURL, Config.DEFAULT_URL);
		commit_changes();
	

func commit_changes():
	config_file.save(CONFIG_FILE_LOCATION);

func get_config():
	return config_file;

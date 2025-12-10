current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "saleem"
client_key               "#{current_dir}/admin.pem"
chef_server_url          "https://chef-server/organizations/alnafi"
cookbook_path            ["#{current_dir}/../cookbooks"]

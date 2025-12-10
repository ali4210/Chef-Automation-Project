# CHECK: Is this machine Windows?
if platform?('windows')

  # ==========================================
  # WINDOWS LOGIC
  # ==========================================

  # 1. SECRET DECRYPTION (WINDOWS)
  # We load the key from C:\chef\
  secret_key = Chef::EncryptedDataBagItem.load_secret('C:\chef\encrypted_data_bag_secret')
  db_creds = Chef::EncryptedDataBagItem.load('my_secrets', 'db_config', secret_key)

  log 'Reveal the Secret' do
    message "WINDOWS SUCCESS! The decrypted password is: #{db_creds['password']}"
    level :warn
  end

  # 2. Install Chocolatey
  powershell_script 'Install Chocolatey' do
    code "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    not_if 'Test-Path "$env:ProgramData\chocolatey\bin\choco.exe"'
  end

  # 3. Install Apache
  chocolatey_package 'apache-httpd' do
    action :install
  end

  # 4. Start Service
  service 'Apache' do
    action [:enable, :start]
  end

# 5. Create Homepage using Template
  template 'C:\Users\Saleem\AppData\Roaming\Apache24\htdocs\index.html' do
    source 'index.html.erb'
    action :create
  end


else

  # ==========================================
  # LINUX LOGIC
  # ==========================================

  # 1. SECRET DECRYPTION (LINUX)
  # We load the key from /etc/chef/
  secret_key = Chef::EncryptedDataBagItem.load_secret('/etc/chef/encrypted_data_bag_secret')
  db_creds = Chef::EncryptedDataBagItem.load('my_secrets', 'db_config', secret_key)

  log 'Reveal the Secret' do
    message "LINUX SUCCESS! The decrypted password is: #{db_creds['password']}"
    level :warn
  end

  # 2. Update Apt
  apt_update 'daily' do
    frequency 86400
    action :periodic
  end

# ... (after apt_update) ...

  # Install Git using the Community Cookbook
  include_recipe 'git::default'

  # ... (before package 'apache2') ...


  # 3. Install Apache
  package 'apache2' do
    action :install
  end

  # 4. Start Service
  service 'apache2' do
    action [:enable, :start]
  end

# 5. Create Homepage using Template
  template '/var/www/html/index.html' do
    source 'index.html.erb'
    mode '0755'
    action :create
  end
end

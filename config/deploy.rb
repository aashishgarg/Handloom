# ------------------------------------------------------------------------ #
# ----------------------- Require Files ---------------------------------- #
# ------------------------------------------------------------------------ #
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'yaml'
require 'io/console'

%w(base nginx mysql check crontab log_rotate product_deployment_sheet).each do |pkg|
  require "#{File.join(__dir__, 'recipes', pkg)}"
end

# ------------------------------------------------------------------------ #
# ----------------------- Set Variables ---------------------------------- #
# ------------------------------------------------------------------------ #
set :application, 'my_application'
set :user, 'deploy'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :repository, repository_url
set :branch, set_branch
set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :sheet_name, 'Product deployment status'
set :work_sheet_name, 'my_application'

set :shared_dirs, fetch(:shared_dirs, []).push('public/system')
set :shared_files, fetch(:shared_file, []).push(
                     'config/database.yml',
                     'config/secrets.yml',
                     'photofy'
                 )
set :ruby_version, "#{File.readlines(File.join(__dir__, '..', '.ruby-version')).first.strip}"
set :gemset, "#{File.readlines(File.join(__dir__, '..', '.ruby-gemset')).first.strip}"

# ======================================================================== #
# ======================= Tasks ========================================== #
# ======================================================================== #

# 11111111111111111111111111111111111111111111111111111111111111111111111111 #
task :environment do
  set :rails_env, ENV['on'].to_sym unless ENV['on'].nil?
  require "#{File.join(__dir__, 'deploy', "#{fetch(:rails_env)}_configurations_files", "#{fetch(:rails_env)}.rb")}"
  invoke :'rvm:use', "ruby-#{fetch(:ruby_version)}@#{fetch(:gemset)}"
end

# 22222222222222222222222222222222222222222222222222222222222222222222222222 #
task setup_prerequesties: :environment  do

  comment %["#{ENV['on']}"]
  set :rails_env, ENV['on'].to_sym unless ENV['on'].nil?
  require "#{File.join(__dir__, 'deploy', "#{fetch(:rails_env)}_configurations_files", "#{fetch(:rails_env)}.rb")}"

  [
      'python-software-properties',
      'libmysqlclient-dev',
      'imagemagick',
      'libmagickwand-dev',
      'nodejs',
      'build-essential',
      'zlib1g-dev',
      'libssl-dev',
      'libreadline-dev',
      'libyaml-dev',
      'libcurl4-openssl-dev',
      'curl',
      'git-core',
      'make',
      'gcc',
      'g++',
      'pkg-config',
      'libfuse-dev',
      'libxml2-dev',
      'zip',
      'libtool',
      'memcached',
      'xvfb',
      'mysql-client',
      'mysql-server',
      'mime-support',
      'automake'
  ].each do |package|
    comment "Installing -------------------------> #{package}"
    command %[sudo -A apt-get install -y #{package}]
  end

  comment "-----> Installing Ruby Version Manager"
  # command %[command curl -sSL https://rvm.io/mpapis.asc | gpg --import]
  # command %[curl -sSL https://get.rvm.io | bash -s stable --ruby]
  #
  # command %[source "#{fetch(:rvm_path)}"]
  # command %[rvm requirements]
  # command %[rvm install "#{fetch(:ruby_version)}"]
  command %[gem install bundler]

  command %[mkdir "#{fetch(:deploy_to)}"]
  command %[chown -R "#{fetch(:user)}" "#{fetch(:deploy_to)}"]

  invoke :'nginx:install'
  invoke :'nginx:setup'
  invoke :'nginx:restart'
end

# 33333333333333333333333333333333333333333333333333333333333333333333333333 #
task setup_yml: :environment do
  Dir[File.join(__dir__, '*.yml.example')].each do |_path|
    command %[echo "#{erb _path}" > "#{File.join(fetch(:deploy_to), 'shared/config', File.basename(_path, '.yml.example') +'.yml')}"]
  end
end

# 44444444444444444444444444444444444444444444444444444444444444444444444444 #
task setup: :environment do
  invoke :set_sudo_password
  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[mkdir -p "#{fetch(:shared_path)}/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]

  command %[mkdir -p "#{fetch(:shared_path)}/photofy"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/photofy"]

  command %[mkdir -p "#{fetch(:shared_path)}/public/system"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/system"]

  invoke :setup_prerequesties
  invoke :setup_yml
  invoke :photofy_setup
end


task :photofy_setup => :environment do
  command %[mkdir -p #{fetch(:deploy_to)}/#{fetch(:shared_path)}/photofy ]
end

# 5555555555555555555555555555555555555555555555555555555555555555555555555555 #
task set_sudo_password: :environment do
  set :sudo_password, ask_sudo
  command "echo '#{erb(File.join(__dir__, 'deploy', "#{fetch(:rails_env)}_configurations_files", 'sudo_password.erb'))}' > /home/#{fetch(:user)}/SudoPass.sh"
  command "chmod +x /home/#{fetch(:user)}/SudoPass.sh"
  command "export SUDO_ASKPASS=/home/#{fetch(:user)}/SudoPass.sh"
end

# 6666666666666666666666666666666666666666666666666666666666666666666666666666 #
desc 'Deploys the current version to the server.'
task :deploy => :environment do
  deploy do
    invoke :'check:revision'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'mysql:create_database'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
  end
  on :launch do
  end
  invoke :restart
end

# 7777777777777777777777777777777777777777777777777777777777777777777777777777 #
desc 'Restart passenger server'
task :restart => :environment do
  # invoke :set_sudo_password
  invoke :'crontab:install'
  command %[sudo -A service nginx restart]
  comment "----------------------------- Start Passenger"
  command %[mkdir -p #{File.join(fetch(:current_path), 'tmp')}]
  command %[touch #{File.join(fetch(:current_path), 'tmp', 'restart.txt')}]
  # invoke :'product_deployment_sheet:update'
end

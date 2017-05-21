#========== Instance Details===============#
set :host_ip, '52.15.158.204'
set :domain, fetch(:host_ip)
#==========================================#

#===============Rails Environment =========#
set :rails_env, 'production'
set :ssl_enabled, false
#==========================================#
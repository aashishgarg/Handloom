#========== Instance Details===============#
set :host_ip, '00.00.000.00'
set :domain, fetch(:host_ip)
#==========================================#

#===============Rails Environment =========#
set :rails_env, 'staging'
set :ssl_enabled, false
#==========================================#
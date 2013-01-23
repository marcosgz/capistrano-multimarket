# run with cap -f ckeck.rb
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capistrano'
set :market_root, 'config/deploy/markets'
require 'capistrano/multimarket'

task :check, :roles => :app do
  pp self[:app_servers]
  pp self[:test_config]
end

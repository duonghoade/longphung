set :stage, :production
set :rails_env, :production

server '45.117.82.79', user: 'root', roles: %w{web app db}, primary: true
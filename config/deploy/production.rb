set :stage, :production
set :rails_env, :production

server '52.221.194.248', user: 'ubuntu', roles: %w{web app db}, primary: true
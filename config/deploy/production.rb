set :stage, :production
set :rails_env, :production

server '163.44.206.110', user: 'root', roles: %w{web app db}, primary: true
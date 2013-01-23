# capistrano-multimarket

## Description

Capistrano extension that allows to use multiple configurations(Ruby and YAML files).

MultiMarket extension is similar to [multistage](https://github.com/capistrano/capistrano-ext) extenstion.
But it's not only about 'stage' configurations. It's about any configuration that you may need.
Extension recursively builds configuration list from configuration root directory.
Each configuration loads recursively configuration from it namespace files and own configuration file.

## Usage

Install gem

    $ gem install capistrano-multimarket


Add to `Capfile`

    set :config, 'path/to/your/markets'
    require 'capistrano/multimarket'

## Example

Assume we have the following configurations:
```bash
$ tree config/
config/
└── deploy
    └── markets
        ├── production
        │   ├── blog
        │   │   ├── site1.rb
        │   │   └── site2.yml
        │   └── blog.rb
        ├── production.rb
        └── staging
            └── blog
                ├── site1.rb
                └── site1.yml
```

Check tasks:
```bash
$ cap -f check.rb -T
cap invoke                # Invoke a single command on the remote servers.
cap production:blog:site1 # Load production:blog:site1 configuration
cap production:blog:site2 # Load production:blog:site2 configuration
cap shell                 # Begin an interactive Capistrano session.
cap staging:blog:site1    # Load staging:blog:site1 configuration
```

Let's try to run task without specified configuration:
```bash
$ cap -f check.rb shell
    triggering start callbacks for `shell'
  * executing `multimarket:ensure'
No configuration specified. Please specify one of:
  * production:blog:site1
  * staging:blog:site1
  * production:blog:site2
(e.g. `cap production:blog:site1 shell')
```

So we must provide configuration as first task:
```bash
$ cap -f check.rb staging:blog:site1 shell
  * executing `staging:blog:site1'
    triggering start callbacks for `shell'
  * executing `multimarket:ensure'
  * executing `shell'
```


### Example of YAML config:
    $ cat examples/config/deploy/markets/staging/blog/site1.yml

```yaml
variables:
  application: 'market1'
  app_servers:
    - web1.example.com
    - web2.example.com
roles:
  app:
    - "app1.example.com"
    - "app2.example.com"
  db:
    - "app1.example.com"
    - {primary: true}
string: |
  set :branch, :master
  role(:web) { fetch(:app_servers) }
```


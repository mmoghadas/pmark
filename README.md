# Pmark

## Requirements
Ruby
Bundler

Configuration File
```bash
cat << EOF > ~/.pmark_config.yml
---
prod:
  access_key_id: ****
  secret_access_key: ****
  compute_endpoint_url: https://ec2.us-west-2.amazonaws.com/
EOF
```

## Prep
```bash
# Install/update required gems
bundle install  #bundle update (if updating)

alias pmark="bundle exec ./bin/pmark"

# grab a list of running apps and run a single command againt the entire list.
pmark exec -e prod -r app123 -u ubuntu -k /Users/mmoghadas/.ssh/key.pem 'dpkg -s vim |grep Version'

- OR -
# grab a list of running apps and run a set of pre-defined commands
pmark exec -e prod -r app123 -u ubuntu -k /Users/mmoghadas/.ssh/key.pem
````

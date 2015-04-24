module PMark
  module Config
    # load config from yaml
    def config
      @config ||= YAML.load_file(ENV.fetch('PMARK_CONFIG', File.join(ENV.fetch('HOME'), '.pmark_config.yml')))
    end
  end
end

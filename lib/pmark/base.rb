require 'rake'
require 'rake/tasklib'
require 'yaml'
require 'fogger'
require 'erubis'

require 'pmark'
require 'pmark/config'

module PMark
  class Base

    include PMark::Config

    attr_reader :fog, :environment

    # initialize and use fog
    def fog
      @fog ||= Fogger.new(config[environment])
    end

    # process erbs
    def template(erb)
      Erubis::Eruby.new(File.read(File.expand_path(erb, __FILE__))).evaluate(data)
    end

  end
end

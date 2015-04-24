require 'clamp'
require 'pmark/base'
require 'pmark/exec'
require 'pmark/cli/exec'

module PMark
  class Cli < Clamp::Command
    subcommand 'exec', 'execute commands on collected servers', CliExec
  end
end

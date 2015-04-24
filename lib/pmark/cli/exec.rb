class CliExec < Clamp::Command

  option ["-e", "--environment"], "ENVIRONMENT", "required: environment", :required => true
  option ["-r", "--role"], "ROLE/TAG", "required: Role/Tag", :required => true
  option ["-u", "--username"], "USERNAME", "required: username to ssh with", :required => true
  option ["-k", "--key"], "KEY File", "required: key file to ssh with", :required => true

  parameter "[command] ...", "command to run", :attribute_name => :command

  def execute
    PMark::Exec.new.servers(environment, role, username, key, command)
  end

end
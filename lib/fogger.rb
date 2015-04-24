require 'fog'

class Fogger

  def initialize(config)
    @config = config
  end

  def compute
    Fog::Compute.new({
      :provider => 'AWS', 
      :aws_access_key_id => @config['access_key_id'],
      :aws_secret_access_key => @config['secret_access_key']})
  end

end
require 'erubis'
require 'net/ssh'
require 'colorize'

module PMark
  class Exec < Base

    attr_reader :discovered_servers, :username, :key

    def servers(environment, role, username, key, command)
      @environment = environment
      @discovered_servers = []
      @username = username
      @key = key
      command = command.join(' ')

      servers = fog.compute.servers.all.select{|s| s.state=='running' && s.tags['role']==role}
      servers.each{|s| discovered_servers << s.public_ip_address}

      if command.empty?
        run_all_commands
      else
        discovered_servers.each do |server|
          format(server, run(command, server))
        end
      end
    end

    def run(cmd, server)
      `ssh -i #{key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet #{username}@#{server} #{cmd}`
    end

    def format(server, output)
      puts "#{server}--->#{output}"
    end

    def run_all_commands
      scan_network
      find_old_servers
      check_package_version
      check_binary_version
      check_memory_and_cpu
    end


    # ----- list taks below -----
    def scan_network
      puts "scanning network interfaces....".green
    end

    def find_old_servers
      puts "finding outdated Ubuntu servers....".green
      cmd = "lsb_release -a|grep Release|awk '{ print $2 }'"
      version_checker(14.04, cmd)
    end

    def check_package_version
      puts "checking package version for vim....".green
      cmd = 'dpkg -s vim |grep Version'
      version_checker(12.6, cmd)
    end

    def check_binary_version
      puts "checking app binary version....".green
      cmd = "vim --version | head -1 | awk -F'[^0-9._,]*' '$0=$2'"
      version_checker(12.6, cmd)
    end

    def check_memory_and_cpu
      puts "checking memory usage for vim....".green
      cmd = "ps aux --sort -rss | grep bash | awk '{ print $3, $4 }'"
      threshold_checker({cpu: 60, memory: 25}, cmd)
    end

    def version_checker(latest_version, cmd)
      discovered_servers.each do |server|
        puts version = run(cmd, server)
        if version.to_f < latest_version
          format(server, version.colorize(:red))
        else
          format(server, version)
        end
      end
    end

    def threshold_checker(threshold, cmd)
      discovered_servers.each do |server|
        puts usage = run(cmd, server)
        cpu = usage.split(' ').first
        memory = usage.split(' ').last
        if cpu.to_f > threshold[:cpu] && memory.to_f > threshold[:memory]
          format(server, usage.colorize(:red))
        else
          format(server, usage)
        end
      end
    end

  end
end

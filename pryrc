Pry.config.history.file = "#{ENV['XDG_DATA_HOME']}/pry/history"

%w[ continue next step ].each do |cmd|
  Pry.commands.alias_command(cmd[0], cmd)
end

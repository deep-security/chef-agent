#helper library for deep security agent cookbook

module DSA_Helpers

  # run a dsa command
  def dsa_control(args, block_name='run_ds_control')

    Chef::Log.info "Running dsa_control with args: #{args}"

    if node[:platform_family] =~ /win/
      powershell_script block_name do
        timeout 600
        code <<-EOH
		    & $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" #{args}
        EOH
      end
    else
      execute block_name do
        timeout 600
        command "/opt/ds_agent/dsa_control #{args}"
      end
    end

  end

end

Chef::Recipe.send(:include, DSA_Helpers)
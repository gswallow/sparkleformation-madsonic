SparkleFormation.dynamic(:auto_scaling_group) do |_name, _config = {}|

  parameters(:disable_termination_on_success) do
    type 'Stirng'
    allowed_values ['true', 'false']
    default 'true'
    description 'Prevent the auto scaling group from terminating your instance if bootstrapping succeeds'
  end

  dynamic!(:auto_scaling_auto_scaling_group, _name).properties do
    availability_zones get_azs!
    min_size 0
    desired_capacity 1
    max_size 1
    launch_configuration_name ref!(_config[:launch_config])
    tags _array(
           -> {
             key 'Name'
             value "#{_name}_asg_instance".to_sym
             propagate_at_launch 'true'
           }
         )
  end

  dynamic!(:auto_scaling_auto_scaling_group, _name).creation_policy do
    resource_signal do
      count 1
      timeout "PT1H"
    end
  end

  dynamic!(:auto_scaling_auto_scaling_group, _name).depends_on "#{_name.capitalize}AutoScalingLaunchConfiguration"
end

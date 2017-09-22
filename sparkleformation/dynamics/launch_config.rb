SparkleFormation.dynamic(:launch_config) do |_name, _config = {}|

  _config[:ami_map]              ||= :region_to_ami
  _config[:iam_instance_profile] ||= "#{_name}_i_a_m_instance_profile".to_sym
  _config[:iam_role]             ||= "#{_name}_i_a_m_role".to_sym
  _config[:ansible_version]      ||= '2.4.0.0-1ppa'

  parameters("#{_name}_instance_type".to_sym) do
    type 'String'
    allowed_values registry!(:ec2_instance_types)
    default _config[:instance_type] || 't2.nano'
  end

  dynamic!(:auto_scaling_launch_configuration, _name).properties do
    image_id map!(_config[:ami_map], region!, :ami)
    instance_type ref!("#{_name}_instance_type".to_sym)
    iam_instance_profile ref!(_config[:iam_instance_profile])
    key_name ref!(:ssh_key_pair)
    security_groups _config[:security_groups]
    user_data registry!(:user_data, _name,
                        :iam_role => ref!(_config[:iam_role]),
                        :launch_config => "#{_name.capitalize}AutoScalingLaunchConfiguration",
                        :resource_id => "#{_name.capitalize}AutoScalingAutoScalingGroup"
                       )
  end

  dynamic!(:auto_scaling_launch_configuration, _name).registry!(:ansible_pull, _name,
           :ansible_seed => _config.fetch(:ansible_seed, {}),
           :ansible_inventory => ref!(:ansible_inventory),
           :ansible_version => ref!(:ansible_version),
           :ansible_playbook_repo => ref!(:ansible_playbook_repo),
           :ansible_playbook_branch => ref!(:ansible_playbook_branch),
           :ansible_local_yaml_path => ref!(:ansible_local_yaml_path),
           :iam_role => ref!(_config[:iam_role])
          )

  dynamic!(:auto_scaling_launch_configuration, _name).depends_on _config[:iam_instance_profile]
end

SparkleFormation.new(:subsonic, :provider => :aws).load(:base, :ami, :ansible, :ssh_key_pair).overrides do
  description <<-EOF
Autoscaling group containing a Subsonic EC2 instance.  S3 bucket to hold media. IAM profile allowing S3 bucket access.
EOF

  parameters(:ansible_playbook_repo) do
    type 'String'
    default ENV.fetch('ansible_playbook_repo', 'https://github.com/indigobio/sparkleformation-indigo-empire.git')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Git repository containing ansible playbook'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:ansible_playbook_branch) do
    type 'String'
    default ENV.fetch('ansible_playbook_branch', 'master')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Git repository branch'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:allow_ssh_from) do
    type 'String'
    allowed_pattern "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    default '127.0.0.1/32'
    description 'Network from which to allow SSH.  Note the default of 127.0.0.1/32 effectively disables SSH access.'
    constraint_description 'Must follow IP/mask notation (e.g. 192.168.1.0/24)'
  end

  parameters(:subsonic_version) do
    type 'String'
    default ENV.fetch('SUBSONIC_VERSION', '6.0')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Version of Subsonic to install'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:subsonic_license_key) do
    type 'String'
    default ENV.fetch('SUBSONIC_LICENSE_KEY', 'not_found')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Version of Subsonic to install'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:subsonic_s3_bucket) do
    type 'String'
    default ENV.fetch('SUBSONIC_S3_BUCKET', "#{ENV['USER']}-subsonic")
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Version of Subsonic to install'
    constraint_description 'can only contain ASCII characters'
  end

  # Security group
  dynamic!(:security_group, 'subsonic',
           :ingress_rules => [
             { :cidr_ip => '0.0.0.0/0', :ip_protocol => 'tcp', :from_port => '4040', :to_port => '4040' },
             { :cidr_ip => ref!(:allow_ssh_from), :ip_protocol => 'tcp', :from_port => '22', :to_port => '22' }
           ]
          )

  # S3 bucket and bucket policy allowing access to IAM roles
  dynamic!(:bucket, 'subsonic', :name => ref!(:subsonic_s3_bucket))
  dynamic!(:bucket_policy, 'subsonic')

  # IAM roles
  dynamic!(:iam_role, 'subsonic')

  dynamic!(:iam_policy, 'subsonic',
           :policy_statements => [ :subsonic_policy_statements],
           :iam_roles => [ 'SubsonicIAMRole']
          )

  dynamic!(:iam_instance_profile, 'subsonic',
           :iam_roles => [ 'SubsonicIAMRole' ],
           :iam_policy => 'SubsonicIAMPolicy'
          )

  # Auto scaling group
  dynamic!(:launch_config, 'subsonic',
           :iam_instance_profile => 'SubsonicIAMInstanceProfile',
           :iam_role => 'SubsonicIAMRole',
           :security_groups => _array(ref!(:subsonic_ec2_security_group)),
           :ansible_seed => registry!(:ansible_seed, 'subsonic')
          )

  dynamic!(:auto_scaling_group, 'subsonic',
           :launch_config => :subsonic_auto_scaling_launch_configuration
          )
end

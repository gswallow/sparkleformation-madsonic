SparkleFormation.new(:madsonic, :provider => :aws).load(:base, :ami, :ansible, :ssh_key_pair).overrides do
  description <<-EOF
Autoscaling group containing a Madsonic EC2 instance.  S3 bucket to hold media. IAM profile allowing S3 bucket access.
EOF

  ENV['BUCKET_NAME'] ||= "#{ENV.fetch('USER', ::Array.new(12) { ::Range.new('a', 'z').to_a.sample }.join)}-madsonic"

  parameters(:ansible_playbook_repo) do
    type 'String'
    default ENV.fetch('ansible_playbook_repo', 'https://github.com/gswallow/sparkleformation-madsonic.git')
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
  
  parameters(:allow_madsonic_from) do
    type 'String'
    allowed_pattern "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    default '0.0.0.0/0'
    description 'Network from which to allow Madsonic (TCP 4040).  Note the default of 0.0.0.0/0 allows global access.'
    constraint_description 'Must follow IP/mask notation (e.g. 192.168.1.0/24)'
  end

  parameters(:madsonic_license_key) do
    type 'String'
    default ENV.fetch('MADSONIC_LICENSE_KEY', '')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Your madsonic license key'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:madsonic_license_email) do
    type 'String'
    default ENV.fetch('MADSONIC_LICENSE_EMAIL', '')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Your madsonic license email'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:madsonic_redirect_from) do
    type 'String'
    default ENV.fetch('MADSONIC_REDIRECT_FROM', ENV.fetch('USER', ''))
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Your madsonic license email'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:madsonic_s3_bucket_name) do
    type 'String'
    default ENV['BUCKET_NAME']
    allowed_pattern "[\\x20-\\x7E]*"
    description 'S3 bucket name -- must be globally unique.'
    constraint_description 'can only contain ASCII characters'
  end

  # Security group
  dynamic!(:security_group, 'madsonic',
           :ingress_rules => [
             { :cidr_ip => ref!(:allow_madsonic_from), :ip_protocol => 'tcp', :from_port => '4040', :to_port => '4040' },
             { :cidr_ip => ref!(:allow_ssh_from), :ip_protocol => 'tcp', :from_port => '22', :to_port => '22' }
           ]
          )

  # S3 bucket and bucket policy allowing access to IAM roles
  dynamic!(:bucket, 'madsonic', :bucket_name => ref!(:madsonic_s3_bucket_name))
  dynamic!(:bucket_policy, 'madsonic')

  # IAM roles
  dynamic!(:iam_role, 'madsonic')

  dynamic!(:iam_policy, 'madsonic',
           :policy_statements => [ :madsonic_policy_statements],
           :iam_roles => [ 'MadsonicIAMRole']
          )

  dynamic!(:iam_instance_profile, 'madsonic',
           :iam_roles => [ 'MadsonicIAMRole' ],
           :iam_policy => 'MadsonicIAMPolicy'
          )

  # Auto scaling group
  dynamic!(:launch_config, 'madsonic',
           :iam_instance_profile => 'MadsonicIAMInstanceProfile',
           :iam_role => 'MadsonicIAMRole',
           :security_groups => _array(ref!(:madsonic_ec2_security_group)),
           :ansible_seed => registry!(:ansible_seed, 'madsonic')
          )

  dynamic!(:auto_scaling_group, 'madsonic',
           :launch_config => :madsonic_auto_scaling_launch_configuration
          )
end

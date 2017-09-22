SfnRegistry.register(:ansible_seed) do |_name, _config = {}|
  {
    'ANSIBLE_LOCAL_TEMP'              => '$HOME/.ansible/tmp',
    'ANSIBLE_REMOTE_TEMP'             => '$HOME/.ansible/tmp',
    'MADSONIC_VERSION'                => ref!(:madsonic_version),
    'MADSONIC_LICENSE_KEY'            => ref!(:madsonic_license_key),
    'MADSONIC_LICENSE_EMAIL'          => ref!(:madsonic_license_email),
    "MADSONIC_REDIRECT_FROM"          => ref!(:madsonic_redirect_from),
    'S3FS_BUCKET_NAME'                => ref!(:madsonic_s3_bucket_name),
    'S3FS_AWS_REGION'                 => region!,
    'S3FS_IAM_ROLE'                   => ref!(:madsonic_i_a_m_role),
    'HOSTGROUP'                       => 'default'
  }
end

SfnRegistry.register(:ansible_seed) do |_name, _config = {}|
  {
    'ANSIBLE_LOCAL_TEMP'              => '$HOME/.ansible/tmp',
    'ANSIBLE_REMOTE_TEMP'             => '$HOME/.ansible/tmp',
    'SUBSONIC_VERSION'                => ref!(:subsonic_version),
    'SUBSONIC_LICENSE_KEY'            => ref!(:subsonic_license_key),
    'SUBSONIC_LICENSE_EMAIL'          => ref!(:subsonic_license_email),
    "SUBSONIC_REDIRECT_FROM"          => ref!(:subsonic_redirect_from),
    'S3FS_BUCKET_NAME'                => ref!(:subsonic_s3_bucket_name),
    'S3FS_AWS_REGION'                 => region!,
    'S3FS_IAM_ROLE'                   => ref!(:subsonic_i_a_m_role),
    'HOSTGROUP'                       => 'default'
  }
end

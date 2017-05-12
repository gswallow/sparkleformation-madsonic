SfnRegistry.register(:ansible_seed) do |_name, _config = {}|
  {
    'ANSIBLE_LOCAL_TEMP'              => '$HOME/.ansible/tmp',
    'ANSIBLE_REMOTE_TEMP'             => '$HOME/.ansible/tmp',
    'SUBSONIC_VERSION'                => ref!(:subsonic_version),
    'SUBSONIC_LICENSE_KEY'            => ref!(:subsonic_license_key),
    'SUBSONIC_S3_BUCKET'              => ref!(:subsonic_s3_bucket),
    'HOSTGROUP'                       => 'default'
  }
end

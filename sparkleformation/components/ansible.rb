SparkleFormation.component(:ansible) do
  parameters(:ansible_version) do
    type 'String'
    default ENV.fetch('ansible_version', '2.4.0.0-1ppa')
  end

  parameters(:ansible_inventory) do
    type 'String'
    default ENV.fetch('ansible_inventory', 'ansible/hosts')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Git repository containing ansible playbook'
    constraint_description 'can only contain ASCII characters'
  end

  parameters(:ansible_playbook_repo) do
    type 'String'
    default ENV.fetch('ansible_playbook_repo', 'https://github.com/gswallow/sparkleformation-subsonic.git')
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

  parameters(:ansible_local_yaml_path) do
    type 'String'
    default ENV.fetch('ansible_local_yaml_path', 'ansible/local.yml')
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Path, in the playbook repository, to find the local.yml file'
    constraint_description 'can only contain ASCII characters'
  end
end

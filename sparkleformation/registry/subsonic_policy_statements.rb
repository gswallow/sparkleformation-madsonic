SfnRegistry.register(:subsonic_policy_statements) do
  [
    {
      'Action' => %w(s3:*),
      'Resource' => join!( join!( 'arn', 'aws', 's3', '', '', ref!(:subsonic_s3_bucket), :options => { :delimiter => ':' }), '*', :options => { :delimiter => '/' }),
      'Effect' => 'Allow'
    },
    {
      'Action' =>  %w(s3:ListBucket),
      'Resource' => join!( 'arn', 'aws', 's3', '', '', ref!(:subsonic_s3_bucket), :options => { :delimiter => ':' })
      'Effect' =>  'Allow'
    },
    {
      'Action' => %w(cloudformation:DescribeStackResource
                   cloudformation:SignalResource
                  ),
      'Resource' => %w( * ),
      'Effect' => 'Allow'
    },
    {
      'Action' => %w( autoscaling:SetInstanceHealth ),
      'Resource' => '*',
      'Effect' => 'Allow'
    },
    {
      'Action' => %w( ec2:DescribeTags ),
      'Resource' => '*',
      'Effect' => 'Allow'
    }
  ]
end

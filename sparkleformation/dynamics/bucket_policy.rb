# This S3 bucket policy allows the arn:aws:iam::Account:root ARN to access
# the bucket being created.  In addition, EC2 instances with IAM instance 
# profiles allowing them to assume IAM roles will be given read access to
# the bucket.
#
# This means that all users in the account ID will have access to the bucket.
# Additionally, any EC2 instance with an IAM role allowing it to assume
# a role with S3 privileges can read objects in the bucket.


SparkleFormation.dynamic(:bucket_policy) do |_name, _config={}|
  dynamic!(:s3_bucket_policy, _name).properties do
    bucket ref!(_config.fetch(:bucket, "#{_name}S3Bucket"))
    policy_document do
      version '2008-10-17'
      id "#{_name}Policy"
      statement _array(
        -> {
          sid "#{_name}BucketOwnerAccess"
          action %w(s3:*)
          effect 'Allow'
          resource join!('arn', 'aws', 's3', '', '', ref!(_config.fetch(:bucket, "#{_name}S3Bucket")), :options => { :delimiter => ':'})
          principal do
            data!['AWS'] = join!('arn', 'aws', 'iam', '', account_id!, 'root', :options => { :delimiter => ':'})
          end
        },
        -> {
          sid "#{_name}ObjectsOwnerAccess"
          action %w(s3:*)
          effect 'Allow'
          resource join!( join!('arn', 'aws', 's3', '', '', ref!(_config.fetch(:bucket, "#{_name}S3Bucket")), :options => { :delimiter => ':'}), '*', :options => { :delimiter => '/'})
          principal do
            data!['AWS'] = join!('arn', 'aws', 'iam', '', account_id!, 'root', :options => { :delimiter => ':'})
          end
        },
        -> {
          sid "#{_name}ObjectsRoleAccess"
          action %w(s3:*)
          effect 'Allow'
          resource join!( join!('arn', 'aws', 's3', '', '', ref!(_config.fetch(:bucket, "#{_name}S3Bucket")), :options => { :delimiter => ':'}), '*', :options => { :delimiter => '/'})
          principal do
            data!['Service'] = 'ec2.amazonaws.com'
          end
        },
        -> {
          sid "#{_name}BucketRoleAccess"
          action %w(s3:List*)
          effect 'Allow'
          resource join!('arn', 'aws', 's3', '', '', ref!(_config.fetch(:bucket, "#{_name}S3Bucket")), :options => { :delimiter => ':'})
          principal do
            data!['Service'] = 'ec2.amazonaws.com'
          end
        }
      )
    end
  end
end

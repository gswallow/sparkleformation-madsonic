SparkleFormation.component(:ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-80861296')
    set!('us-east-2'.disable_camel!, :ami => 'ami-618fab04')
    set!('us-west-1'.disable_camel!, :ami => 'ami-2afbde4a')
    set!('us-west-2'.disable_camel!, :ami => 'ami-efd0428f')
  end
end

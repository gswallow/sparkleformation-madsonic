SparkleFormation.component(:ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-1d4e7a66')
    set!('us-east-2'.disable_camel!, :ami => 'ami-dbbd9dbe')
    set!('us-west-1'.disable_camel!, :ami => 'ami-969ab1f6')
    set!('us-west-2'.disable_camel!, :ami => 'ami-8803e0f0')
    set!('ca-central-1'.disable_camel!, :ami => 'ami-a9c27ccd')
    set!('eu-west-1'.disable_camel!, :ami => 'ami-674cbc1e')
    set!('eu-west-2'.disable_camel!, :ami => 'ami-03998867')
    set!('eu-central-1'.disable_camel!, :ami => 'ami-958128fa')
  end
end

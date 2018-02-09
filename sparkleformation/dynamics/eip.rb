SparkleFormation.dynamic(:eip) do |_name|

  dynamic!(:e_c_2_e_i_p, _name).properties do
    domain 'vpc'
    tags _array(
      -> {
        key 'Purpose'
        value 'madsonic'
      }
    )
  end
end

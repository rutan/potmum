class PotmumAPI < Grape::API
  mount ::PotmumAPIs::V1::Root

  add_swagger_documentation
end

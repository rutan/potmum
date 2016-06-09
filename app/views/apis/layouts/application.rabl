node(:uuid) { SecureRandom.uuid }
node(:status) { status }
node(:error) { @error } if @error
node(:responsed_at) { Time.zone.now }


result = Yajl::Parser.parse(yield)
node(:data) { result } if result.present?

Konpow.configure do |config|
  config.base_path = 'asset_pack'
  config.manifest_path = Rails.root.join('webpack-manifest.json')
  config.dev_host = ENV['WEBPACK_DEV_SERVER_URL'] || 'http://localhost:8080'
end

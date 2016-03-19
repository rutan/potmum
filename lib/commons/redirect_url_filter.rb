require 'cgi'

class RedirectURLFilter < HTML::Pipeline::Filter
  def call
    doc.search('a').each do |node|
      url = node.attr('href')
      next unless url

      next if url.index('#') == 0 # OK: #hoge
      next if url.match(/\A\/[^\/]/) # OK: /hoge
      if GlobalSetting.root_url.present?
        next if url.index("#{GlobalSetting.root_url}/") == 0 # OK: http://podmum-url/hoge
        next if url.index("//#{GlobalSetting.root_url.sub(/\Ahttps?:/, '')}/") == 0 # OK: //podmum-url/hoge
      end
      if GlobalSetting.attachment_file_s3?
        next if url.index(GlobalSetting.attachment_file_s3_host) == 0 # OK
      end

      node.set_attribute('href', "/redirect?url=#{CGI.escape(url)}")
    end
    doc
  end
end

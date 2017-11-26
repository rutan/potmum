# frozen_string_literal: true

require 'cgi'

class RedirectURLFilter < HTML::Pipeline::Filter
  def call
    doc.search('a').each do |node|
      url = node.attr('href')
      next unless url

      next if url.start_with?('#') # OK: #hoge
      next if url.match?(%r{\A/[^/]}) # OK: /hoge
      if GlobalSetting.root_url.present?
        next if url.start_with?("#{GlobalSetting.root_url}/") # OK: http://podmum-url/hoge
        next if url.start_with?("//#{GlobalSetting.root_url.sub(/\Ahttps?:/, '')}/") # OK: //podmum-url/hoge
      end
      if GlobalSetting.attachment_file_s3?
        next if url.start_with?(GlobalSetting.attachment_file_s3_host) # OK
      end

      node.set_attribute('href', "/redirect?url=#{CGI.escape(url)}")
    end
    doc
  end
end

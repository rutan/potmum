# frozen_string_literal: true

require 'cgi'

class RedirectURLFilter < HTML::Pipeline::Filter
  def call
    doc.search('a').each do |node|
      url = node.attr('href')
      next unless url
      next if local_link?(url)
      next if site_link?(url)
      next if attachment_file_link?(url)

      node.set_attribute('href', "/redirect?url=#{CGI.escape(url)}")
    end
    doc
  end

  private

  def local_link?(url)
    return true if url.start_with?('#') # ex) #hoge
    return true if url.match?(%r{\A/[^/]}) # ex) /hoge

    false
  end

  def site_link?(url)
    return false unless GlobalSetting.root_url.present?

    return true if url.start_with?("#{GlobalSetting.root_url}/") # ex) http://podmum-url/hoge
    return true if url.start_with?("//#{GlobalSetting.root_url.sub(/\Ahttps?:/, '')}/") # ex) //podmum-url/hoge

    false
  end

  def attachment_file_link?(url)
    return false unless GlobalSetting.attachment_file_s3?
    url.start_with?(GlobalSetting.attachment_file_s3_host)
  end
end

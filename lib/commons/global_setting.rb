module GlobalSetting
  def self.private_mode?
    ENV['PRIVATE_MODE'].to_i != 0
  end

  def self.root_url
    ENV['ROOT_URL'] || ''
  end

  def self.use_redirector?
    ENV['USE_REDIRECTOR'].to_i != 0
  end

  def self.use_external_widget?
    ENV['USE_EXTERNAL_WIDGET'].to_i != 0
  end

  def self.gravatar_url
    ENV['GRAVATAR_URL'] || 'https://www.gravatar.com/avatar'
  end

  def self.use_global_alert?
    ENV['GLOBAL_ALERT'].present?
  end

  def self.global_alert
    ENV['GLOBAL_ALERT'] || ''
  end

  def self.auth_methods
    @auth_methods ||= begin
      methods = []

      # Google OAuth
      if ENV['USE_GOOGLE'].to_i != 0
        methods << {
          name: ENV['GOOGLE_APPS_DOMAIN'].present? ? ENV['GOOGLE_APPS_DOMAIN'] : 'Google',
          path: 'google_oauth2'
        }
      end

      # GitHub
      if ENV['USE_GITHUB'].to_i != 0
        methods << {
          name: ENV['GITHUB_ENTERPRISE_URL'] ? 'GitHub:e' : 'GitHub',
          path: 'github'
        }
      end

      # Slack
      if ENV['USE_SLACK'].to_i != 0
        methods << {
          name: "Slack#{ENV['SLACK_TEAM_NAME'] ? "(#{ENV['SLACK_TEAM_NAME']})" : ''}",
          path: 'slack'
        }
      end

      # Twitter
      if ENV['USE_TWITTER'].to_i != 0
        methods << {
          name: 'Twitter',
          path: 'twitter'
        }
      end

      methods
    end
  end

  def self.notify_slack?
    notify_slack_channel.present?
  end

  def self.notify_slack_channel
    ENV['NOTIFY_SLACK_CHANNEL']
  end

  def self.notify_slack_icon
    ENV['NOTIFY_SLACK_ICON']
  end

  def self.notify_slack_token
    ENV['NOTIFY_SLACK_TOKEN']
  end

  def self.theme_name
    COLOR_THEME_LIST.key?(ENV['COLOR_THEME']) ? ENV['COLOR_THEME'] : 'blue'
  end

  def self.theme_colors
    COLOR_THEME_LIST[theme_name]
  end

  COLOR_THEME_LIST = JSON.parse(File.read(Rails.root.join('data', 'colors.json'))).freeze

  def self.use_attachment_file?
    ENV['USE_ATTACHMENT_FILE'].present?
  end

  def self.attachment_file_s3?
    attachment_file_s3_bucket.present?
  end

  def self.attachment_file_s3_bucket
    ENV['ATTACHMENT_FILE_S3_BUCKET']
  end

  def self.attachment_file_s3_acl
    ENV['ATTACHMENT_FILE_S3_ACL'] || 'public-read'
  end

  def self.attachment_file_s3_host
    ENV['ATTACHMENT_FILE_S3_HOST'] || begin
      if attachment_file_s3_force_path_style
        "https://#{attachment_file_s3_bucket}.s3.amazonaws.com"
      else
        "https://#{attachment_file_s3_region}.amazonaws.com/#{attachment_file_s3_bucket}"
      end
    end
  end

  def self.attachment_file_s3_key
    ENV['ATTACHMENT_FILE_S3_KEY']
  end

  def self.attachment_file_s3_secret
    ENV['ATTACHMENT_FILE_S3_SECRET']
  end

  def self.attachment_file_s3_region
    ENV['ATTACHMENT_FILE_S3_REGION']
  end

  def self.attachment_file_s3_endpoint
    ENV['ATTACHMENT_FILE_S3_ENDPOINT']
  end

  def self.attachment_file_s3_force_path_style
    n = ENV['ATTACHMENT_FILE_S3_FORCE_PATH_STYLE']
    n ? (n.to_i > 0) : nil
  end
end

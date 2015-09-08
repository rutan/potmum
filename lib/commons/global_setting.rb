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

      # GitHub
      if ENV['USE_GITHUB']
        methods << {
            name: ENV['GITHUB_ENTERPRISE_URL'] ? 'GitHub:e' : 'GitHub',
            path: 'github',
        }
      end

      # Slack
      if ENV['USE_SLACK']
        methods << {
            name: "Slack#{ENV['SLACK_TEAM_NAME'] ? "(#{ENV['SLACK_TEAM_NAME']})" : ''}",
            path: 'slack',
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
    COLOR_THEME_LIST.has_key?(ENV['COLOR_THEME']) ? ENV['COLOR_THEME'] : 'blue'
  end

  def self.theme_colors
    COLOR_THEME_LIST[theme_name]
  end

  COLOR_THEME_LIST = {
      'red' => ['#e57373', '#ef5350', '#f44336', '#d32f2f'],
      'pink' => ['#f06292', '#ec407a', '#e91e63', '#c2185b'],
      'purple' => ['#ba68c8', '#ab47bc', '#9c27b0', '#7b1fa2'],
      'deep_purple' => ['#9575cd', '#7e57c2', '#673ab7', '#512da8'],
      'indigo' => ['#7986cb', '#5c6bc0', '#3f51b5', '#303f9f'],
      'blue' => ['#64b5f6', '#42a5f5', '#2196f3', '#1976d2'],
      'light_blue' => ['#4fc3f7', '#29b6f6', '#03a9f4', '#0288d1'],
      'cyan' => ['#4dd0e1', '#26c6da', '#00bcd4', '#0097a7'],
      'teal' => ['#4db6ac', '#26a69a', '#009688', '#00796b'],
      'green' => ['#81c784', '#66bb6a', '#4caf50', '#388e3c'],
      'light_green' => ['#aed581', '#9ccc65', '#8bc34a', '#689f38'],
      'lime' => ['#dce775', '#d4e157', '#cddc39', '#afb42b'],
      'yellow' => ['#fff176', '#ffee58', '#ffeb3b', '#fbc02d'],
      'amber' => ['#ffd54f', '#ffca28', '#ffc107', '#ffa000'],
      'orange' => ['#ffb74d', '#ffa726', '#ff9800', '#f57c00'],
      'deep_orange' => ['#ff8a65', '#ff7043', '#ff5722', '#e64a19'],
      'brown' => ['#a1887f', '#8d6e63', '#795548', '#5d4037'],
      'grey' => ['#e0e0e0', '#bdbdbd', '#9e9e9e', '#616161'],
      'blue_grey' => ['#90a4ae', '#78909c', '#607d8b', '#455a64']
  }

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

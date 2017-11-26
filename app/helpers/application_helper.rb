# frozen_string_literal: true

module ApplicationHelper
  def current_user
    @current_user
  end

  def global_alert
    GlobalSetting.use_global_alert? ? GlobalSetting.global_alert : nil
  end
end

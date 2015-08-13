class AttachmentFilesController < ApplicationController
  before_action :require_login!

  # POST /attachment_files.json
  def create
    raise Errors::NotFound unless GlobalSetting.use_attachment_file?

    @attachment_file = AttachmentFile.new(
        user: current_user,
        file: params[:file]
    )
    if @attachment_file.save
      render_json @attachment_file, status: 201
    else
      render_json({}, status: 400)
    end
  end
end

module TurboFrameHelper
  def turbo_frame_id
    request.env['HTTP_TURBO_FRAME']
  end

  def turbo_frame?
    turbo_frame_id.present?
  end

  def turbo_frame_with_id_tag(...)
    turbo_frame_tag(turbo_frame_id, ...)
  end
end
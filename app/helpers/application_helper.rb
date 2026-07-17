module ApplicationHelper
  include CurrentUserHelper
  include FormHelper
  include FormulaHelper
  include SpriteHelper
  include StatHelper
  include ZodiacHelper

  def modal_classes
    content_for(:modal_classes) || ''
  end
end

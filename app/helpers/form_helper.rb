module FormHelper
  def text_field_classes
    '
      bg-right
      py-0
      px-0
      bg-transparent
      border-0
      border-b-2
      border-menu-dark
      appearance-none
      focus:outline-none
      focus:ring-0
      peer
      w-full
      placeholder-menu-dark
    '.squish
  end

  def select_classes
    '
      bg-right
      cursor-pointer
      w-24
      py-0
      px-0
      bg-transparent
      border-0
      border-b-2
      border-transparent
      hover:border-menu-dark
      appearance-none
      focus:outline-none
      focus:ring-0
      focus:border-menu-dark
      peer
    '.squish
  end

  def primary_button_classes
    '
      cursor-pointer
      focus:outline-none
      text-white
      focus:ring-4
      font-medium
      rounded-lg
      text-sm
      px-5
      py-2.5
      bg-blue-600
      hover:bg-blue-700
      focus:ring-blue-800
    '.squish
  end

  def neutral_button_classes
    '
      text-gray-900
      bg-white
      border
      border-gray-300
      focus:outline-none
      hover:bg-gray-100
      focus:ring-4
      focus:ring-gray-200
      font-medium
      rounded-lg
      text-sm
      px-5
      py-2.5
    '.squish
  end

  def wrap_tooltip(&block)
    tag.div(capture(&block), class: 'z-30 absolute hidden px-3 pointer-events-none shadow-lg bg-menu-texture border-2 border-menu-dark min-w-[29rem]', data: { context_target: 'tooltip' })
  end
end

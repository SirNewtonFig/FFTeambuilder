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

  def text_field_classes_neutral
    '
      bg-right
      py-0
      px-0
      bg-transparent
      border-0
      border-b-2
      border-gray-400
      appearance-none
      focus:outline-none
      focus:ring-0
      peer
      w-full
      placeholder-gray-500
    '.squish
  end

  def text_area_classes_neutral
    '
      appearance-none
      py-0
      px-0
      bg-transparent
      border-0
      border-b-2
      border-gray-400
      appearance-none
      outline-none
      focus:ring-0
      peer
      w-full
      placeholder-gray-500
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

  def select_classes_neutral
    '
      bg-right
      cursor-pointer
      py-0
      px-0
      bg-transparent
      border-0
      border-b-2
      border-transparent
      hover:border-gray-600
      appearance-none
      focus:outline-none
      focus:ring-0
      focus:border-gray-600
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
      hover:bg-blue-500
      focus:ring-blue-800
    '.squish
  end

  def destructive_button_classes
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
      bg-red-600
      hover:bg-red-500
      focus:ring-red-800
    '.squish
  end

  def confirm_button_classes
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
      bg-green-500
      hover:bg-green-400
      focus:ring-green-700
    '.squish
  end

  def neutral_button_classes
    '
      text-white
      bg-white
      focus:outline-none
      bg-gray-500
      hover:bg-gray-400
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
    tag.div(
      capture(&block),
      class: '
        z-30
        absolute
        hidden
        px-3
        pointer-events-none
        shadow-lg
        bg-menu-texture
        border-2
        border-menu-dark
        sm:w-[34rem]
      '.squish,
      data: { context_target: 'tooltip' }
    )
  end

  def wrap_tooltip_neutral(&block)
    tag.div(capture(&block), class: 'z-30 absolute hidden shadow-lg bg-gray-700 left-0 rounded font-sans', data: { context_target: 'tooltip' })
  end

  def readonly_link_to(name, href, readonly: false, **options)
    return tag.span(name, **options) if readonly

    link_to(name, href, **options)
  end
end

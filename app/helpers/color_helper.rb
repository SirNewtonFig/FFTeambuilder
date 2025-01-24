module ColorHelper
  COLOR_MAP = {
    blue: 'bg-blue-500',
    red: 'bg-red-500',
    green: 'bg-green-500',
    white: 'bg-white',
    purple: 'bg-fuchsia-700',
    yellow: 'bg-yellow-300',
    brown: 'bg-yellow-800',
    black: 'bg-black'
  }.with_indifferent_access

  def palette_class(palette_value)
    COLOR_MAP[palette_value]
  end
end

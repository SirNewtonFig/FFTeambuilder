const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/models/**/*.rb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js'
  ],
  theme: {
    extend: {
      backgroundImage: {
        'menu-texture': "url(bg.gif)"
      },

      colors: {
        'menu': {
          DEFAULT: '#A49D83',
          'dark': '#726C5E'
        },

        'mp': {
          'light': '#A2AD7D',
          'dark': '#556872'
        },

        'hp': {
          'light': '#C9985D',
          'dark': '#78483F'
        },

        'ct': {
          'light': '#A6A658',
          'dark': '#59694A'
        }
      },

      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      },

      skew: {
        '45': '-45deg'
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('flowbite/plugin')
  ]
}

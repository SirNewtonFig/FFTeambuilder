require "administrate/base_dashboard"

class ItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    data: Field::JSONB.with_options(transform: %w[to_h with_indifferent_access]),
    item_type: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    jobs: Field::HasMany.with_options(limit: false),
    name: Field::Text.with_options(searchable: true),
    proficiencies: Field::HasMany,
    skills: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    item_type
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    item_type
    data
    jobs
    skills
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name  
    item_type
    data
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {
    accessory: ->(resources) { resources.accessory },
    armor: ->(resources) { resources.armor },
    helmet: ->(resources) { resources.helmet },
    shield: ->(resources) { resources.shield },
    weapon: ->(resources) { resources.weapon }
  }.freeze

  # Overwrite this method to customize how items are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(item)
    item.name
  end
end

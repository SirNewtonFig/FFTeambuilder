require "administrate/base_dashboard"

class JobDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::Text.with_options(searchable: true),
    skillset: Field::Text,
    abbreviation: Field::Text,
    data: Field::JSONB.with_options(transform: %w[to_h with_indifferent_access]),
    innate_skills: Field::HasMany.with_options(collection_attributes: %i[name], limit: false),
    monster_passives: Field::HasMany.with_options(collection_attributes: %i[name], limit: false),
    prerequisites: Field::HasMany.with_options(collection_attributes: %i[prerequisite level], limit: false),
    skills: Field::HasMany.with_options(collection_attributes: %i[name jp_cost skill_type], limit: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    abbreviation
    updated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    abbreviation
    skillset
    data
    skills
    innate_skills
    monster_passives    
    prerequisites
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    abbreviation
    skillset
    data
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  COLLECTION_FILTERS = {
    monsters: ->(resources) { resources.monster },
    generics: ->(resources) { resources.generic }
  }.freeze

  # Overwrite this method to customize how jobs are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(job)
    job.name
  end
end

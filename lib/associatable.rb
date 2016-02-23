require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    default = {
      foreign_key: "#{name}_id".to_sym,
      primary_key: :id,
      class_name: name.singularize.camelcase
    }
    options = default.merge(options)
    self.foreign_key = options[:foreign_key]
    self.primary_key = options[:primary_key]
    self.class_name = options[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    default = {
      foreign_key: "#{self_class_name.underscore}_id".to_sym,
      primary_key: :id,
      class_name: name.singularize.camelcase
    }
    options = default.merge(options)
    self.foreign_key = options[:foreign_key]
    self.primary_key = options[:primary_key]
    self.class_name = options[:class_name]
  end
end

module Associatable
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name.to_s, options)
    relation = assoc_options[name]
    define_method(name.to_s) {
      id = self.send(relation.foreign_key)
      relation.model_class.find(id)
    }
  end

  def has_many(name, options = {})
    self_class_name = self.to_s
    options1 = HasManyOptions.new(name.to_s, self_class_name, options)
    define_method(name.to_s) {
      id = self.id
      options1.model_class.where(options1.foreign_key => id)
    }
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name.to_s) {
      source_options = through_options.model_class.assoc_options[source_name]
      id = self.send(through_options.foreign_key)
      query = DBConnection.execute(<<-SQL, id)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name} ON
          #{through_options.table_name}.#{source_options.foreign_key} =
          #{source_options.table_name}.id
        WHERE
          #{through_options.table_name}.id = ?
      SQL
    source_options.model_class.parse_all(query).first
    }
  end
end

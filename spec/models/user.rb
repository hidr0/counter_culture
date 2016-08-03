class User < ActiveRecord::Base
  belongs_to :employer

  belongs_to :manages_company, :class_name => "Company"
  counter_culture :manages_company, :column_name => "managers_count"
  belongs_to :has_string_id
  counter_culture :has_string_id

  has_many :reviews
  accepts_nested_attributes_for :reviews, :allow_destroy => true

  attr_reader :name_writes

  def name=(name)
    @name_writes ||= 0
    @name_writes += 1
    write_attribute(:name, name)
  end

  def clear_name_writes
    @name_writes = 0
  end

  default_scope do
    if _default_scope_enabled
      joins("LEFT OUTER JOIN companies").uniq
    else
      all
    end
  end

  class << self
    attr_accessor :_default_scope_enabled

    def with_default_scope
      @_default_scope_enabled = true
      yield
      @_default_scope_enabled = false
    end
  end
end

# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def meta_hash
    meta.deep_symbolize_keys
  end

  def meta_assign(name, args)
    meta_will_change!
    meta[name] = args[0]
  end

  def meta_retrieve(name)
    meta_hash&.fetch(name, nil)
  end

  def self.meta_attr(key)
    define_method("#{key}=") do |*fields|
      meta_assign(key, fields)
    end
    define_method(key) do |*_f|
      meta_retrieve(key)
    end
  end
end

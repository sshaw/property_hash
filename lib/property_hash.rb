# frozen_string_literal: true

class PropertyHash
  include Enumerable

  KEY_DELIMITER = "."
  VERSION = "0.0.1"

  def initialize(hash, use_symbols = true)
    @hash = hash
    @keys = keys_as_properties(hash)
    @use_symbols = use_symbols || false
  end

  def each
    # TODO: return to_enum unless block_given?
    @keys.each { |key| yield([key, self[key]]) }
  end

  def keys
    @keys.dup
  end

  def values
    map(&:last)
  end

  def [](key)
    keys = key.to_s.split(KEY_DELIMITER)
    # Does not support mixed keys
    v = @hash.dig(*keys)
    return v unless v.nil? && @use_symbols

    keys.map!(&:to_sym)
    @hash.dig(*keys)
  end

  private

  def keys_as_properties(hash)
    props = []

    hash.each do |k, v|
      if v.is_a?(Hash)
        props.concat(property_flatten(k.to_s, v))
      else
        props << k.to_s
      end
    end

    props
  end

  def property_flatten(root, h)
    h.map do |k, v|
      prop = [root, k]
      prop = property_flatten(prop.join("."), v) if v.is_a?(Hash)
      prop.join(".")
    end
  end
end

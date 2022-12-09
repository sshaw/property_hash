# frozen_string_literal: true

class PropertyHash
  include Enumerable

  KEY_DELIMITER = "."
  VERSION = "0.0.1"

  def initialize(hash, use_symbols = true)
    @hash = hash.dup
    @keys = keys_as_properties(hash)
    @use_symbols = use_symbols || false
  end

  def each
    return to_enum(:each) unless block_given?
    @keys.each { |key| yield([key, self[key]]) }
  end

  def keys
    @keys.dup
  end

  def values
    map(&:last)
  end

  def to_h
    @hash.dup
  end

  alias to_hash to_h

  def []=(key, value)
    keys = property_key(key)
    hash_to_set = @hash

    keys[0..-2].each do |key|
      if hash_to_set.include?(key)
        hash_to_set = hash_to_set[key]
      else
        hash_to_set = hash_to_set[key] = {}
      end
    end

    @keys << key

    hash_to_set[keys[-1]] = value
  end

  def [](key)
    keys = property_key(key)
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

  def property_key(value)
    keys = value.to_s.split(KEY_DELIMITER)
    keys.map!(&:to_sym) if @use_symbols
    keys
  end

  def property_flatten(root, h)
    h.map do |k, v|
      prop = [root, k]
      prop = property_flatten(prop.join(KEY_DELIMITER), v) if v.is_a?(Hash)
      prop.join(KEY_DELIMITER)
    end
  end
end

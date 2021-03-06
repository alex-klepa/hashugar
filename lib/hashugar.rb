require "hashugar/version"

class Hashugar
  def initialize(hash)
    @table = {}
    @table_with_original_keys = {}
    hash.each_pair do |key, value|
      hashugar = value.to_hashugar
      @table_with_original_keys[key] = hashugar
      @table[convert_key(key)] = hashugar
    end
  end

  def method_missing(method, *args, &block)
    method = method.to_s
    if method.chomp!('=')
      self[method] = args.first
    else
      @table[method]
    end
  end

  def [](key)
    @table[convert_key(key)]
  end

  def []=(key, value)
    @table[convert_key(key)] = value
  end

  def to_hashugar
    self
  end

  def respond_to?(key)
    @table.has_key?(convert_key(key))
  end

  def each(&block)
    @table_with_original_keys.each(&block)
  end

  def collect(&block)
    @table_with_original_keys.collect(&block)
  end
  
  def select(&block)
    @table_with_original_keys.select(&block)
  end

  def reject(&block)
    @table_with_original_keys.reject(&block)
  end
  
  def any?(&block)
    @table_with_original_keys.any?(&block)
  end
  
  def keys
    @table_with_original_keys.keys
  end

  def values
    @table_with_original_keys.values
  end
  
  def length
    @table_with_original_keys.length
  end
  
  def invert
    @table_with_original_keys.invert
  end

  private
  def convert_key(key)
    key.is_a?(Symbol) ? key.to_s : key
  end
end

class Hash
  def to_hashugar
    Hashugar.new(self)
  end
end

class Array
  def to_hashugar
    # TODO lazy?
    Array.new(collect(&:to_hashugar))
  end
end

class Object
  def to_hashugar
    self
  end
end
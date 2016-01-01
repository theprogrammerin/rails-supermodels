module SuperModels
  class Settings < ActiveRecord::Base
    self.abstract_class = true

    as_enum :env_enum, [:development, :test, :feature, :production], strings: true, column: :env

    attr_accessible :id, :key, :value, :env, :created_at, :updated_at

    after_save :clear_cache
    after_destroy :clear_cache

    public

    #
    # Caches all the settings in rails cache store for a give model
    #
    def self.cache_all_settings
      puts "Caching settings for #{self.name}"
      where(env: Rails.env).each do |rec|
        rec.set_cache
      end
    end

    #
    # Expires all the settings cache
    #
    def self.expire_all_settings_cache
      where(env: Rails.env).each do |rec|
        rec.send :clear_cache
      end
    end

    #
    # This is interface to world for creating, removing settings
    #
    # @param [String|Symbol] key Setting key which to be used for saving.
    # @param [Primary DataType] value value which need to be stored, can be any primary data type.
    #
    # @return [Boolean] Whether save was success or failure
    #
    def self.set(key, value)
      key = key.to_s
      rec = where(key: key, env: Rails.env).first_or_initialize
      # To retain data type
      rec.value = { actual_value: value }.to_json
      rec.save
    end
    singleton_class.send(:alias_method, :[]=, :set)

    #
    # This is interface for accessing settings.
    #
    # @param [String|Symbol] key Settings which need to reterived.
    #
    # @return [Primary Datatype] stored value for key
    #
    def self.get(key)
      key = key.to_s
      Rails.cache.fetch(cache_key(key), expires_in: 24.hours) do
        rec = where(key: key, env: Rails.env).first
        raise ActiveRecord::RecordNotFound if rec.nil?
        rec.actual_value
      end
    end
    singleton_class.send(:alias_method, :[], :get)

    #
    # Sets the cache for current record
    #
    #
    # @return [Boolean] Cache write success/failed
    #
    def set_cache
      cache_key = self.class.cache_key(self.key)
      Rails.cache.write(cache_key, self.actual_value)
    end

    #
    # Reterives the actual value from the stored string.
    #
    #
    # @return [Primary Datatype] The actual value which was set.
    #
    def actual_value
      JSON.parse(self.value)['actual_value']
    end

    # As this does not clears the cache, it is not allowed.
    def self.update_all
      raise StandardError.new("Mass overwriting of settings not allowed")
    end

    private

    #
    # Clears the cache for current record
    #
    #
    # @return [Boolean] Result of cache deletion
    #
    def clear_cache
      Rails.cache.delete(self.class.cache_key(self.key))
    end

    #
    # Generates cache key for the given key, this is MD5 of Environment, cache prefix.
    #
    # @param [String] key The key to be used for generating cache key
    #
    # @return [String] MD5 of the cache key
    #
    def self.cache_key(key)
      Digest::MD5.hexdigest("settings/#{Rails.env}/#{cache_prefix}/#{key}")
    end

    #
    # The cache prefix to be used, this is underscored version of class name
    #
    #
    # @return [String] underscored class name.
    #
    def self.cache_prefix
      self.name.underscore
    end

  end
end

module ActsAsCounterCacheable
  def acts_as_counter_cacheable
    after_save    :update_counter_cache
    after_destroy :update_counter_cache
    include InstanceMethods
  end

  module InstanceMethods
    def update_counter_cache
      self.activity.update_sub_activity_cache if self.class == SubActivity
      self.data_response.update_counter_caches(self.class)
    end
  end
end

ActiveRecord::Base.extend ActsAsCounterCacheable
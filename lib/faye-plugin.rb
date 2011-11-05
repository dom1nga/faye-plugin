module FayePlugin

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods

    def faye_watcher(object, attribute)
      content_tag(:div, "#{object[attribute.to_sym]}", {:id => "#{object.class.name.downcase}_#{object.id}_#{attribute}"})
    end

    def broadcast(&block)
      @faye_client.publish '/listener', :data => capture(&block)
    end

  end
end

ActionView::Base.send(:include, FayePlugin) if defined?(ActionView::Base)

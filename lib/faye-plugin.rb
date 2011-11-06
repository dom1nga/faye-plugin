module FayePlugin

  module HelperAdditions

    def self.included(base)
      base.send :include, InstanceMethods
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

  module ControllerAdditions

    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods

      private

      def find_faye_client
          @faye_client = env['faye.client']
      end

      def set_faye_client_for_observer
        ActionObserver.faye_client = env['faye.client']
      end
    end
  end

end

ActionView::Base.send(:include, FayePlugin::HelperAdditions) if defined?(ActionView::Base)
ActionController::Base.class_eval { include FayePlugin::ControllerAdditions } if defined? ActionController

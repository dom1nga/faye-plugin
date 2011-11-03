class FayePluginObserver < ActiveRecord::Observer
  observe Rails.configuration.faye_observers

  def broadcast_message(channel, data)
    message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://#{Rails.configuration.faye_host}:#{Rails.configuration.faye_port}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def before_update(model)
    if model.changed?
      @client_changes = lambda do
        model.changes.each do |key, value|
          broadcast_message("/listener", "$(\"##{model.class.name.downcase}_#{model.id}_#{key}\").html(\"#{value[1]}\")")
        end
      end
    else
      @client_changes = lambda {}
    end
  end

  def after_update(model)
    @client_changes.call
  end
end
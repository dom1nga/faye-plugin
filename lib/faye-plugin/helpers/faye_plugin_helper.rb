module FayePluginHelper
  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://#{Rails.configuration.faye_host}:#{Rails.configuration.faye_port}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def faye_watcher(object, attribute)
    content_tag(:div, "#{object[attribute.to_sym]}", {:id => "#{object.class.name.downcase}_#{object.id}_#{attribute}"})
  end
end
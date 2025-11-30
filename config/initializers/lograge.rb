Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_options = lambda do |event|
    request = event.payload[:request]
    
    {
      time: Time.now.utc.iso8601(3),
      params: event.payload[:params].except('controller', 'action', 'utf8', '_method', 'authenticity_token', 'password', 'token'),
      ip: request.remote_ip,
      referer: request.referer,
      request_id: request.request_id,
      session_id: (request.session.id rescue nil),
      user_agent: request.user_agent,
      exception: event.payload[:exception],
      exception_object: event.payload[:exception_object]
    }
  end
end
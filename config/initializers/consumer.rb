channel = RabbitMq.channel
queue = channel.queue('auth', durable: true)

def extracted_token(token)
  JwtEncoder.decode(token)
rescue JWT::DecodeError
  {}
end

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON(payload)
  client = AdsService::RpcClient.fetch
  uuid = extracted_token(payload['token'])['uuid']
  result = Auth::FetchUserService.call(uuid)

  client.pass_user_id(result.user&.id, properties.correlation_id)
  channel.ack(delivery_info.delivery_tag)
end

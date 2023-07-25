# frozen_string_literal: true

module AdsService
  module RpcApi
    def pass_user_id(user_id, correlation_id)
      payload = { user_id: user_id }.to_json
      publish(payload, type: 'user_id', correlation_id: correlation_id)
    end
  end
end

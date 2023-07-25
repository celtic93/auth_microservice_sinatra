# frozen_string_literal: true

require_relative 'rpc_api'

module AdsService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    option :queue, default: proc { create_queue }
    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def self.fetch
      Thread.current['ads_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe do |_delivery_info, properties, _payload|
        @lock.synchronize { @condition.signal } if properties[:correlation_id] == @correlation_id
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('user-id', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('auth.rabbitmq.reply-to')
    end

    def publish(payload, opts = {})
      self.correlation_id = opts[:correlation_id]

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(app_id: 'auth', reply_to: @reply_queue.name)
        )

        @condition.wait(@lock)
      end
    end
  end
end

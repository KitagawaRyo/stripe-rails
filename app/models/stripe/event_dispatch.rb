require 'stripe/event'
module Stripe
  module EventDispatch
    def dispatch_stripe_event(params, json)
      retrieve_stripe_event(params, json) do |evt|
        if evt.respond_to?(:data) && evt.data.respond_to?(:object)
          target = evt.data.object
          ::Stripe::Callbacks.run_callbacks(evt, target)
        else
          target = evt.data[:object]
          ::Stripe::Callbacks.run_callbacks(evt, target)
        end
      end
    end

    def retrieve_stripe_event(params, json)
      id = params['id']
      account = params['account']
      if id == 'evt_00000000000000' #this is a webhook test
        yield Stripe::Event.construct_from(json)
      elsif account.nil?
        yield Stripe::Event.retrieve(id)
      else 
        event = Stripe::Event.retrieve(id, {stripe_account: account})
        event.account = account
        yield event
      end
    end
  end
end

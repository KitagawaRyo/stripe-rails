require 'stripe/event'
module Stripe
  module EventDispatch
    def dispatch_stripe_event(params)
      retrieve_stripe_event(params) do |evt|
        target = evt.data.object
        ::Stripe::Callbacks.run_callbacks(evt, target)
      end
    end

    def retrieve_stripe_event(params)
      id = params['id']
      user_id = params['user_id']
      if id == 'evt_00000000000000' #this is a webhook test
        yield Stripe::Event.construct_from(params)
      elsif user_id.nil?
        yield Stripe::Event.retrieve(id)
      else 
        yield Stripe::Event.retrieve(id, {stripe_account: user_id})
      end
    end
  end
end
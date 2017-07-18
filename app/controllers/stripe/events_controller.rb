module Stripe
  class EventsController < ::Stripe::ApplicationController
    include Stripe::EventDispatch
    respond_to :json

    def create
      json = JSON.parse(request.body.read)
      @event = dispatch_stripe_event(params, json)
      respond_with @event, :location => nil
    end
  end
end
require 'stripe/callbacks/builder'

module Stripe
  module Callbacks
    include Callbacks::Builder

    callback 'account.updated'
    callback 'account.application.deauthorized'
    callback 'balance.available'
    callback 'charge.succeeded'
    callback 'charge.failed'
    callback 'charge.refunded'
    callback 'charge.captured'
    callback 'charge.dispute.created'
    callback 'charge.dispute.updated'
    callback 'charge.dispute.closed'
    callback 'customer.created'
    callback 'customer.updated'
    callback 'customer.deleted'
    callback 'customer.card.created'
    callback 'customer.card.updated'
    callback 'customer.card.deleted'
    callback 'customer.subscription.created'
    callback 'customer.subscription.updated'
    callback 'customer.subscription.deleted'
    callback 'customer.subscription.trial_will_end'
    callback 'customer.discount.created'
    callback 'customer.discount.updated'
    callback 'customer.discount.deleted'
    callback 'invoice.created'
    callback 'invoice.updated'
    callback 'invoice.payment_succeeded'
    callback 'invoice.payment_failed'
    callback 'invoiceitem.created'
    callback 'invoiceitem.updated'
    callback 'invoiceitem.deleted'
    callback 'plan.created'
    callback 'plan.updated'
    callback 'plan.deleted'
    callback 'coupon.created'
    callback 'coupon.updated'
    callback 'coupon.deleted'
    callback 'transfer.created'
    callback 'transfer.updated'
    callback 'transfer.paid'
    callback 'transfer.failed'
    callback 'ping'
    callback 'stripe.event'
    callback 'connect.account.updated'
    callback 'connect.account.application.deauthorized'
    callback 'connect.balance.available'
    callback 'connect.charge.succeeded'
    callback 'connect.charge.failed'
    callback 'connect.charge.refunded'
    callback 'connect.charge.captured'
    callback 'connect.charge.dispute.created'
    callback 'connect.charge.dispute.updated'
    callback 'connect.charge.dispute.closed'
    callback 'connect.customer.created'
    callback 'connect.customer.updated'
    callback 'connect.customer.deleted'
    callback 'connect.customer.card.created'
    callback 'connect.customer.card.updated'
    callback 'connect.customer.card.deleted'
    callback 'connect.customer.subscription.created'
    callback 'connect.customer.subscription.updated'
    callback 'connect.customer.subscription.deleted'
    callback 'connect.customer.subscription.trial_will_end'
    callback 'connect.customer.discount.created'
    callback 'connect.customer.discount.updated'
    callback 'connect.customer.discount.deleted'
    callback 'connect.invoice.created'
    callback 'connect.invoice.updated'
    callback 'connect.invoice.payment_succeeded'
    callback 'connect.invoice.payment_failed'
    callback 'connect.invoiceitem.created'
    callback 'connect.invoiceitem.updated'
    callback 'connect.invoiceitem.deleted'
    callback 'connect.plan.created'
    callback 'connect.plan.updated'
    callback 'connect.plan.deleted'
    callback 'connect.coupon.created'
    callback 'connect.coupon.updated'
    callback 'connect.coupon.deleted'
    callback 'connect.transfer.created'
    callback 'connect.transfer.updated'
    callback 'connect.transfer.paid'
    callback 'connect.transfer.failed'
    callback 'connect.ping'
    callback 'connect.stripe.event'

    class << self
      def run_callbacks(evt, target)
        if !evt.respond_to?(:account)
          _run_callbacks evt.type, evt, target
          _run_callbacks 'stripe.event', evt, target
        else 
          _run_callbacks "connect.#{evt.type}", evt, target
          _run_callbacks 'stripe.event', evt, target
        end
      end

      def _run_callbacks(type, evt, target)
        run_critical_callbacks type, evt, target
        run_noncritical_callbacks type, evt, target
      end

      def run_critical_callbacks(type, evt, target)
        ::Stripe::Callbacks::critical_callbacks[type].each do |callback|
          callback.call(target, evt)
        end
      end

      def run_noncritical_callbacks(type, evt, target)
        ::Stripe::Callbacks::noncritical_callbacks[type].each do |callback|
          begin
            callback.call(target, evt)
          rescue Exception => e
            ::Rails.logger.error e.message
            ::Rails.logger.error e.backtrace.join("\n")
          end
        end
      end
    end
  end
end

class Cart < ApplicationRecord
  include AASM
  has_many :orders, dependent: :delete_all
  belongs_to :user
  belongs_to :offer, optional: true
  validate do |cart|
    errors.add(:Status, *@status_error) if @status_error
  end

  aasm column: :status do
    state :unconfirmed, initial: true
    state :confirmed
    state :pending
    state :cancelled
    state :delivered


    event :pending do
      transitions from: :unconfirmed, to: :pending
    end

    event :confirm do
      transitions from: :pending, to: :confirmed

      # after do
      #   update_patient_address
      #   update_amount
      # end
    end

    event :cancel do
      transitions from: [:unconfirmed, :pending, :confirmed], to: :cancelled

      # after do
      #   update_patient_address
      #   update_amount
      # end
    end

    event :deliver do
      transitions from: :confirmed, to: :delivered
    end
    error_on_all_events :set_transition_error

    after_all_transitions :set_timestamp
  end

  def set_transition_error
    @status_error = [ "errors.cannot_transit", { event: aasm.current_event } ]
  end

  def set_timestamp
    self.send("#{aasm.to_state}_at=", Time.now)
  end
end

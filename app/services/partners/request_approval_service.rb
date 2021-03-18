module Partners
  class RequestApprovalService
    include ServiceObjectErrorsMixin

    def initialize(partner:)
      @partner = partner
    end

    def call
      return self unless valid?

      partner.profile.update(partner_status: 'submitted')
      partner.awaiting_review!

      self
    end

    private

    attr_reader :partner

    def valid?
      if partner.profile.partner_status == 'submitted'
        errors.add(:base, 'partner has already requested approval')
      end

      errors.none?
    end
  end
end

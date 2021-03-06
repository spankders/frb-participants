module FrbParticipants
  class InstitutionName
    def self.find_by_frb_name(frb_name)
      attributes = {
        frb_name: frb_name,
        # known_normalized_name may be `nil`.
        known_normalized_name: data[frb_name],
        # Attempt to automatically capitalize name correctly, in case the actual
        # normalization is unknown.
        best_attempt_normalized_name: frb_name.split('-').map(&:titleize).join('-'),
      }
      OpenStruct.new(attributes)
    end

    def self.data
      @@institution_name_data ||= plaid_data.merge(manual_data)
    end

    def self.plaid_data
      @@plaid_data ||= FrbParticipants::Data.load("plaid-institution-names.yml")
    end

    def self.manual_data
      @@manual_data ||= FrbParticipants::Data.load("manually-normalized-institution-names.yml")
    end
  end
end

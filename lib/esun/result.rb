module Esun
  class Result
    attr_accessor :handle_date, :channel,
                  :serial_number, :vaccount,
                  :oid, :amount,
                  :pay_time, :data

    def initialize(attrs)
      attrs.each do |column, value|
        self.send("#{column}=", value)
      end
    end
  end
end

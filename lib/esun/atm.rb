module Esun
  class ATM
    # Setup the compnay_code when init your rails app
    # config/initializers/esun.rb
    # Esun::ATM.company_code = Settings.esun.company_code
    cattr_accessor :company_code
    @@company_code = ''

    WEIGHTING_TABLE = '654321987654321'

    class << self
      # 局號
      def bank_code
        '808'
      end

      # 取得虛擬帳號
      def build_vaccount(oid, amount, expire_date)
        unless expire_date.is_a?(Date)
          raise "expire_date must be is Date"
        end
        # 訂單編號 000001
        oid = get_oid_format(oid)
        # 限制日期 10/10
        expire_date = expire_date.strftime('%m%d')
        # 虛擬帳號
        vaccount = "#{company_code}#{expire_date}#{oid}"
        # 檢查碼
        check_numbers = check_numbers_generator(amount, vaccount)

        vaccount = "#{vaccount}#{check_numbers}"
        unless vaccount.length == 16
          raise "vaccount generate error (not = 16 length) output: '#{vaccount}'"
        end
        return vaccount
      end

      private
        # OID 6 碼 (000001)
        def get_oid_format(oid)
          oid = oid.to_i.to_s.rjust(6, '0')
          unless oid.length == 6
            raise "OID over 6 chars output: #{oid.to_s}"
          end
          return oid
        end

        # 檢查碼檢查
        def check_numbers_generator(amount, vaccount)
          return ((get_weight_code(amount) + get_weight_code(vaccount)) % 10).to_s
        end

        # 取得 numbers weight
        def get_weight_code(numbers)
          numbers = numbers.to_s
          weight = WEIGHTING_TABLE.reverse[0, numbers.length].reverse
          return numbers.split('').map.with_index { |number, index| (number.to_i * weight[index].to_i) }.sum.to_i
        end
    end
  end
end

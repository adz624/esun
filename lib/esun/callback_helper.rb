module Esun
  module CallbackHelper
    extend ActiveSupport::Concern
    # 玉山銀行 Callback IP
    WHIT_LIST_IPS = %w(203.67.45.142 61.220.45.142 127.0.0.1 192.241.217.93)

    module ClassMethods
      protected
        # 增加 white list IP
        # Example:
        # add_allow_ip '127.0.0.1'
        # add_allow_ip '127.0.0.1', '123.212.346.45'
        def add_allow_ip(ips)
          if ips.is_a? Array
            WHIT_LIST_IPS.contcat(ips)
          else
            WHIT_LIST_IPS.push(ips.to_s)
          end
        end

        # 1. 跳過 Rails 4 預設 authenticity_token 驗證
        # 2. 設定 IP Whit List before_action
        def set_esun_callback_action(action)
          action = action.to_sym
          skip_before_filter :verify_authenticity_token, only: action
          before_action :esun_callback_ip_check, only: action
        end
    end

    protected
      # 檢查 IP Before Action
      def esun_callback_ip_check
        unless WHIT_LIST_IPS.include?(remote_ip)
          raise ActionController::RoutingError.new('IP not allow')
        end
      end

      def render_esun_ok
        render text: 'OK'
      end

      def remote_ip
        (request.headers['HTTP_X_REAL_IP'] || request.remote_ip) if request.present?
      end

      # Parse 玉山 Callback
      def payment_params
        @payment_params ||= parse_payment_params(params[:Data])
      end

      def parse_payment_params(data)
        payment_parameters = data.gsub('0D 0A', '').split(',')
        oid = payment_parameters[3][9, 6]
        return ::Esun::Result.new(
          handle_date: Date.parse(payment_parameters[0]),
          channel: payment_parameters[1],
          serial_number: payment_parameters[2],
          vaccount: payment_parameters[3],
          oid: oid.to_i,
          amount: payment_parameters[4].to_i,
          pay_time: Time.parse(payment_parameters[5]),
          data: data)
      end
  end
end

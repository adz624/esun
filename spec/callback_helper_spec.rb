require 'spec_helper'

class PaymentController < ActionController::Base
  include ::Esun::CallbackHelper
  add_allow_ip '192.168.3.10'
  set_esun_callback_action :esun

  def esun; end
end


describe PaymentController do
  it "192.168.3.10 should in white list CONST" do
    ::Esun::CallbackHelper::WHIT_LIST_IPS.should include('192.168.3.10')
  end

  it "#payment_params" do
    payment_params = subject.send(:parse_payment_params, "20140311,銀行,1,965730312000988,10000,20140311133132")
    payment_params.should be_a(::Esun::Result)
    payment_params.oid.should == 988
    payment_params.vaccount.length.should == 15
    payment_params.amount.should == 10000
  end
end

require 'spec_helper'

Esun::ATM.company_code = '92424'

describe Esun::ATM do
  subject { ::Esun::ATM }

  it "company code should exists" do
    subject.company_code.should == '92424'
  end

  its(:bank_code) { should == '808' }

  context "when create a virtual account" do
    subject { ::Esun::ATM.build_vaccount(1, 1000, Date.parse('2014/03/18') ) }

    its(:length) { should == 16}

    it "should match compnay_code == 92424" do
      subject[0..4].should == '92424'
    end

    it "order_id should auto fill 0 => 000001" do
      subject[9..14].should == '000001'
      subject[9..14].to_i.should == 1
    end
  end
end

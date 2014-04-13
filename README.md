### 玉山銀行虛擬帳號 generator / payment callback parser


##### 注意事項 (玉山金流地雷)

1. 玉山 callback server 有 DNS Cache，如果 production 換 IP 網址沒換，一樣會送到到舊的 IP
2. callback action 如果沒有回傳 `render_esun_ok` 就會連續 query 10 次

##### 安裝 / 使用


Gemfile

`gem 'esun'`

`bundle install`


```ruby config/router.rb
  post "payment/esun"
```

```ruby payment_controller.rb
class PaymentController < ActionController::Base
  include ::Esun::CallbackHelper
  add_allow_ip '192.168.3.10' # 如果在開發時、需要設定 white list 可以加上
  set_esun_callback_action :esun # 指定 esun callback action

  # 此 action 接收金劉公司 callback
  # POST /payment/esun
  def esun
    payment_params.data       # 原始 post 過來的資料

    payment_params.oid         # 訂單編號
    payment_params.amount      # 金額
    payment_params.pay_time    # 付款時間
    payment_params.handle_date # 忘了是什麼?! 知道的人告訴我一下

    # .... 你的 business logic

    # 回應 200 - OK
    render_esun_ok
  end
end
```


##### 有任何問題

請 email 至 eddie [at] visionbundles.com

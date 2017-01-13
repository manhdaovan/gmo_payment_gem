# gmo_payment_gem
[Github](https://github.com/manhdaovan/gmo_payment_gem) <br/>
Unofficial wrapper for GMO Payment Gateway API <br/>
Easy to make request to GMO Payment Gateway <br/>

### Background
* Need a simple scenario about payment,
eg: Register member and credit card info, then execute monthly payment
* Do not want to know others api with a ton of documents
* Lightweight library with no dependency, simple configurations, and extend easily

### Install
* In `Gemfile`: `gem 'gmo_payment_gem'` then `$bundle install`
* Or directly with: `$gem install gmo_payment_gem`

### Configuration

* For rails app:
 In `config/environment.rb`, insert: `require 'gmo_payment' unless defined?(GmoPayment)` <br/>
 then in `config/environments/env_file.rb` (Eg: `config/environments/development.rb`):

```
   config.after_initialize do
       GmoPayment::Configurations.all = {
         site_id: ENV['DEV_PAYMENT_SITE_ID'],
         site_pass: ENV['DEV_PAYMENT_SITE_PASS'],
         shop_id: ENV['DEV_PAYMENT_SHOP_ID'],
         shop_pass: ENV['DEV_PAYMENT_SHOP_PASS'],
         log_path: "#{Rails.root.to_s}/log/dev.log",
         base_url: ENV['DEV_PAYMENT_BASE_URL'],
         more_urls: {},
         more_errors: {}
       }
       GmoPayment::Configurations.check_valid!
   end
```

* For other apps/libs:
```
require 'gmo_payment'
```
then fill above config to where init your app.

* Configurations description

| Key        | Required? | Value format  |   Description   |
|:-----------|:--------- |:------------- |:--------------- |
| site_id    | Yes       | String        |                 |
| site_pass  | Yes       | String        |                 |
| shop_id    | Yes       | String        |                 |
| shop_pass  | Yes       | String        |                 |
| log_path   | Yes       | String        | Use for log file|
| base_url   | Yes       | String        | Use for base url of request endpoint.<br/> Eg: With endpoint: `https://pt01.mul-pay.jp/payment/SaveCard.idPass`<br/>then `base_url` is `https://pt01.mul-pay.jp/payment`|
| more_urls  | No        | Hash          | Use for extend/overwrite existing api urls endpoint|
| more_errors| No        | Hash          | Use for extend/overwrite existing api errors|

# Usage
Wherever you need to execute a request to GMO Payment

* For version 0.0.1
```
# options = {}, type_site = true, logger = nil is default params
gmo_payment = GmoPayment.new
# Prepare your params here
params = {}
#List support_request see as bellow
response = gmo_payment.support_request(params)
if response.success?
  # Do your stuff here
end
```

* For version >= 0.0.2
```
# options = {}, type_site = true, logger = nil is default params
gmo_payment = GmoPayment::Api.new
# Prepare your params here
params = {}
#List support_request see as bellow
response = gmo_payment.support_request(params)
if response.success?
  # Do your stuff here
end
```

* List `support_request`
:register_member<br/>
:delete_member<br/>
:search_member<br/>
:save_card<br/>
:delete_card<br/>
:register_transaction<br/>
:submit_transaction<br/>
:confirm_transaction<br/>
:transaction_status<br/>

# Extend
If you don't see what request you need in list `support_request`,
you can define your request with simple code as below:
```
class YourPayment < GmoPayment
  def request_your_api(params = {})
    # You can define request url to above config in more_urls hash
    api_url = GmoPayment::ApiUrls.fetch('YOUR_API_REQUEST_KEY')
    call_api(api_url, params)
  end
end
```
then
```
your_payment = YourPayment.new
params = {} # Define your request params here
response = your_payment.request_your_api(params)
response.success do |api_url, response_http_code, response_body, response_body_parsed|
 # Your code to define how is success
end
```
# Development
All PR are welcome.
Make sure all test cases are passed by command:
`$rake test`

# TODO
* RDoc
* validate request params base on each type of request

# Changelog
Please ref to [Changelog](./CHANGELOG.md)

# License
MIT.


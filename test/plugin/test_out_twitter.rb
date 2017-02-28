require 'helper'
require 'fluent/test/driver/output'
require 'fluent/plugin/out_twitter'

class TwitterOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    consumer_key        CONSUMER_KEY
    consumer_secret     CONSUMER_SECRET
    access_token        ACCESS_TOKEN
    access_token_secret ACCESS_TOKEN_SECRET
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::TwitterOutput).configure(conf)
  end

  sub_test_case "configure" do
  def test_configure
    assert_raise(Fluent::ConfigError) {
      d = create_driver('')
    }
    d = create_driver %[
      consumer_key        CONSUMER_KEY
      consumer_secret     CONSUMER_SECRET
      access_token        ACCESS_TOKEN
      access_token_secret ACCESS_TOKEN_SECRET
    ]
    assert_equal 'CONSUMER_KEY', d.instance.consumer_key
    assert_equal 'CONSUMER_SECRET', d.instance.consumer_secret
    assert_equal 'ACCESS_TOKEN', d.instance.access_token
    assert_equal 'ACCESS_TOKEN_SECRET', d.instance.access_token_secret
  end

  def test_configure_compatible
    d = create_driver %[
      consumer_key        CONSUMER_KEY
      consumer_secret     CONSUMER_SECRET
      oauth_token         ACCESS_TOKEN
      oauth_token_secret  ACCESS_TOKEN_SECRET
    ]
    assert_equal 'CONSUMER_KEY', d.instance.consumer_key
    assert_equal 'CONSUMER_SECRET', d.instance.consumer_secret
    assert_equal 'ACCESS_TOKEN', d.instance.access_token
    assert_equal 'ACCESS_TOKEN_SECRET', d.instance.access_token_secret
  end
  end
end

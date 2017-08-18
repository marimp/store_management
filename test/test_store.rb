require 'minitest/autorun'
require './checkout.rb'

class Test < Minitest::Test

  @@pricing_rules=['cardigantwoforone', 'tshirtdiscountforthree']

  def setup_deployment
  end

  def teardown
  end

  def test_1
    store=Checkout.new(@@pricing_rules)
    store.scan("CARDIGAN")
    store.scan("TSHIRT")
    store.scan("TROUSERS")
    assert_equal('45.5€', store.total)
  end

  def test_2
    store=Checkout.new(@@pricing_rules)
    store.scan("CARDIGAN")
    store.scan("TSHIRT")
    store.scan("CARDIGAN")
    assert_equal('30.0€', store.total)
  end

  def test_3
    store=Checkout.new(@@pricing_rules)
    store.scan("TSHIRT")
    store.scan("TSHIRT")
    store.scan("TSHIRT")
    store.scan("CARDIGAN")
    store.scan("TSHIRT")
    assert_equal('57.0€', store.total)
  end

  def test_4
    store=Checkout.new(@@pricing_rules)
    store.scan("CARDIGAN")
    store.scan("TSHIRT")
    store.scan("CARDIGAN")
    store.scan("CARDIGAN")
    store.scan("TROUSERS")
    store.scan("TSHIRT")
    store.scan("TSHIRT")
    assert_equal('82.5€', store.total)
  end

end

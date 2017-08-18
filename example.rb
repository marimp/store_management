#!/usr/bin/env ruby

require './checkout.rb'

pricing_rules=['cardigantwoforone', 'tshirtdiscountforthree']

store=Checkout.new(pricing_rules)
store.scan("CARDIGAN")
store.scan("TSHIRT")
store.scan("CARDIGAN")
store.scan("CARDIGAN")
store.scan("TROUSERS")
store.scan("TSHIRT")
store.scan("TSHIRT")
store.total

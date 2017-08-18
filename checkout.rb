require 'yaml'
require './price_rule.rb'

class Checkout
  # Constants
  STORE_FILE = 'store.yaml'

  def initialize(rules=[])
    store_hash=YAML.load(File.read(STORE_FILE)) # entire store hash
    @store = store_hash['store']                # store hash elements
    @currency = store_hash['currency']          # currency hash elements
    @discounts = store_hash['discounts']        # discounts hash elements
    @pricing_rules=rules                        # list of discount rules to apply
  end


  # It applies the baseprice (prices without any discount) and applies the discounts according to the discount rules
  #
  # * *Args*    :
  # * *Returns* :
  # * *Raises* :
  #
  def apply_rules
    @rule_instance=PriceRules.new(@discounts,@store)
    @rule_instance.apply_baseprice
    @pricing_rules.each { |rule|
      @rule_instance.send "apply_#{rule}"  # invokes the method related to the particular rule
    }
  end

  # It sums the items subtotals for generating the total price
  #
  # * *Args*    :
  # * *Returns* :
  #   - the total price
  #
  def apply_total
    total=0
    @rule_instance.store.select {|_,itemq| itemq['quantity']}.each do |_,item|
      total += item['subtot'] if item['quantity']
    end
    total
  end

  # It scans the product item and collects the @store
  # Example {
  #   "CARDIGAN"=>{"code"=>"CARDIGAN", "name"=>"Cardigan", "price"=>5.0, "quantity"=>3},
  #   "TSHIRT"=>{"code"=>"TSHIRT", "name"=>"T-Shirt", "price"=>20.0, "quantity"=>3},
  #   "TROUSERS"=>{"code"=>"TROUSERS", "name"=>"Trousers", "price"=>7.5, "quantity"=>1}
  #  }
  #
  # * *Args*    :
  #   - +item+ -> The item is defined in store.yaml. At the moment: CARDIGAN, TROUSERS; TSHIRT
  # * *Returns* :
  # * *Raises* :
  #   - +RuntimeError+ -> if the item is not present in the store
  #
  def scan item
    unless @store.key? item
      raise "ERROR: code #{item} not present in the store"
    end
    @store[item]['quantity'] = (@store[item]['quantity']) ? @store[item]['quantity'] + 1 : 1
  end

  # It reports the total
  #
  # * *Args*    :
  # * *Returns* :
  #   - the total amount
  # * *Raises* :
  #
  def total
    # Apply Rules
    apply_rules
    puts "Product   |  Quantity  |  Original Price  |  Discounted (if applied)"
    @rule_instance.store.each { |_,item|
      discounted = (item['subtotal']) ? item['subtotal'] : item['price']
      puts "#{item['name']} | x#{item['quantity']} | #{item['price']} | #{discounted}"
    }

    puts "  Total: #{apply_total}#{@currency}"
    return "#{apply_total}#{@currency}"
  end

  private :apply_rules, :apply_total

end
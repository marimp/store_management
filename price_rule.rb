class PriceRules
  attr_accessor :store

  # It dynamically generated the methods able to apply the discounts (and generate the new subtotal)
  # according to the discount rules
  #
  # * *Args*    :
  #   - +discounts_list+ -> The list of discounts to be applied
  #   - +store_checkout+ -> the @store containing the items scanned
  # * *Returns* :
  # * *Raises* :
  #   - +RuntimeError+ -> if the item is not present in the store
  #
  def initialize(discounts_list, store_checkout=[])
    @store = store_checkout
    discounts_list.each { |rule_name,rule|
      # Dynamically create rules method
      self.class.send('define_method','apply_' + rule_name) do
        @store.select {|codeq,itemq| itemq['quantity'] and codeq==rule['type']}.each{|code,item| # applied for items to be discounted
          if item['quantity'] / rule['group'] > 0
            quantity_to_not_discount = item['quantity'] % rule['group']
            quantity_to_discount = item['quantity'] - quantity_to_not_discount
            price_for_item_to_discount = item['price'] - item['price'] * rule['discount']
            item['subtot'] = quantity_to_not_discount * item['price'] + quantity_to_discount * price_for_item_to_discount
          end
        }
      end
    }
  end

  # It applies the baseprice to all items
  #
  # * *Args*    :
  # * *Returns* :
  # * *Raises* :
  #
  def apply_baseprice
    @store.select {|_,itemq| itemq['quantity']}.each { |_,item|
      item['subtot'] = item['price'] * item['quantity']
    }
  end

end
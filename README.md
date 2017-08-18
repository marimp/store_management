# Store Management

## Requirements

#### There are only three products in the store:

``` 
Code         | Name                |  Price
-------------------------------------------------
CARDIGAN     | Cardigan            |  20.00€
TSHIRT       | T-Shirt             |  10.00€
TROUSERS     | Trousers            |  15.50€
```

#### There are the following discounts:

 * 2-for-1 promotions (buy two of the same product, get one free) for `CARDIGAN` items.

 * discounts on bulk purchases (buying x or more of a product, the price of that product is reduced): buy 3 or more `TSHIRT` items, the price per unit should be 9.00€.

#### The items could be scanned in any order, and should return the total amount to be paid. This is the interface (ruby):

```ruby
co = Checkout.new(pricing_rules)
co.scan("CARDIGAN")
co.scan("TSHIRT")
co.scan("TROUSERS")
price = co.total
```

#### Examples:

    Items: CARDIGAN, TSHIRT, TROUSERS
    Total: 45.50€

    Items: CARDIGAN, TSHIRT, CARDIGAN
    Total: 30.00€

    Items: TSHIRT, TSHIRT, TSHIRT, CARDIGAN, TSHIRT
    Total: 57.00€

    Items: CARDIGAN, TSHIRT, CARDIGAN, CARDIGAN, TROUSERS, TSHIRT, TSHIRT
    Total: 82.50€
    
## Run Tests

#### With Docker:
```ruby
docker-compose build
docker-compose up
```
    
#### Standalone:
```ruby
rake
```
    
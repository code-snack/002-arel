# Code Snack - 002 - Arel

## Examples

```ruby
Product.arel_table
# => #<Arel::Table:0x00007fd18cbb1ce0
#  @name="products",
#  @table_alias=nil,
#  @type_caster=#<ActiveRecord::TypeCaster::Map:0x00007fd18cbb1d30 @types=Product(id: integer, name: string, price: float, active: boolean, created_at: datetime, updated_at: datetime)>>

Product.arel_table[:id]
# => #<struct Arel::Attributes::Attribute
#  relation=
#   #<Arel::Table:0x00007fd18cbb1ce0
#    @name="products",
#    @table_alias=nil,
#    @type_caster=#<ActiveRecord::TypeCaster::Map:0x00007fd18cbb1d30 @types=Product(id: integer, name: string, price: float, active: boolean, created_at: datetime, updated_at: datetime)>>,
#  name=:id>

Product.arel_table[:name]
# => #<struct Arel::Attributes::Attribute
#  relation=
#   #<Arel::Table:0x00007fd18cbb1ce0
#    @name="products",
#    @table_alias=nil,
#    @type_caster=#<ActiveRecord::TypeCaster::Map:0x00007fd18cbb1d30 @types=Product(id: integer, name: string, price: float, active: boolean, created_at: datetime, updated_at: datetime)>>,
#  name=:name>

Product.where('name ILIKE ?', '%shoe%')
# SELECT "products".* FROM "products" WHERE (name ILIKE '%shoe%')

Product.where(Product.arel_table[:name].matches('%shoe%'))
# SELECT "products".* FROM "products" WHERE "products"."name" ILIKE '%shoe%'

Product.where(Product.arel_table[:name].eq('shoe'))
# SELECT "products".* FROM "products" WHERE "products"."name" = 'shoe'

Product.where(Product.arel_table[:name].in(['shoe', 'sneakers']))
# SELECT "products".* FROM "products" WHERE "products"."name" IN ('shoe', 'sneakers')

Product.where(Product.arel_table[:price].gt(100))
# SELECT "products".* FROM "products" WHERE "products"."price" > 100.0

Product.where(Product.arel_table[:price].gteq(100))
# SELECT "products".* FROM "products" WHERE "products"."price" >= 100.0

Product.where(Product.arel_table[:price].lt(100))
# SELECT "products".* FROM "products" WHERE "products"."price" < 100.0

Product.where(Product.arel_table[:price].lteq(100))
# SELECT "products".* FROM "products" WHERE "products"."price" <= 100.0

Product.where(Product.arel_table[:name].not_eq('shoe'))
# SELECT "products".* FROM "products" WHERE "products"."name" != 'shoe'

Product.where(Product.arel_table[:name].not_in(['shoe', 'sneakers']))
# SELECT "products".* FROM "products" WHERE "products"."name" NOT IN ('shoe', 'sneakers')

Product.where(Product.arel_table[:name].eq('shoe')).where(Product.arel_table[:id].eq(1))
# SELECT "products".* FROM "products" WHERE "products"."name" = 'shoe' AND "products"."id" = 1

Product.where(Product.arel_table[:name].eq('shoe').or(Product.arel_table[:id].eq(1)))
# SELECT "products".* FROM "products" WHERE ("products"."name" = 'shoe' OR "products"."id" = 1)

name = Product.arel_table[:name]
Product.where(name.eq('shoe').or(Product.arel_table[:id].eq(1).and(name.matches('%sneakers%'))))
# SELECT "products".* FROM "products" WHERE ("products"."name" = 'shoe' OR "products"."id" = 1 AND "products"."name" ILIKE '%sneakers%')

Product.where(Arel::Nodes::NamedFunction.new('LENGTH', [Product.arel_table[:name]]).gteq(50))
# SELECT "products".* FROM "products" WHERE LENGTH("products"."name") >= 50

Arel::Nodes::NamedFunction.new('LENGTH', [Product.arel_table[:name]]).gteq(50).class
# => Arel::Nodes::GreaterThanOrEqual

Product.arel_table[:name].eq('shoe').class
# => Arel::Nodes::Equality

Product.select(Arel::Nodes::NamedFunction.new('LENGTH', [Product.arel_table[:name]]))
# SELECT LENGTH("products"."name") FROM "products"

Product.order(Arel::Nodes::NamedFunction.new('LENGTH', [Product.arel_table[:name]]))
# SELECT "products".* FROM "products" ORDER BY LENGTH("products"."name")

Product.order(Arel::Nodes::NamedFunction.new('LENGTH', [Product.arel_table[:name]]).desc)
# SELECT "products".* FROM "products" ORDER BY LENGTH("products"."name") DESC

Category.joins('LEFT OUTER JOIN products ON products.category_id = categories.id')
# SELECT "categories".* FROM "categories" LEFT OUTER JOIN products ON products.category_id = categories.id

categories = Category.arel_table
products = Product.arel_table
Category.joins(
  categories.create_join(
    products,
    products.create_on(categories[:id].eq(products[:category_id])),
    Arel::Nodes::OuterJoin)
)
# SELECT "categories".* FROM "categories" LEFT OUTER JOIN "products" ON "categories"."id" = "products"."category_id"

Category.joins(
  categories.create_join(
    products,
    products.create_on(categories[:id].eq(products[:category_id]).and(products[:name].not_eq(nil))),
    Arel::Nodes::OuterJoin)
)
# SELECT "categories".* FROM "categories" LEFT OUTER JOIN "products" ON "categories"."id" = "products"."category_id" AND "products"."name" IS NOT NULL
```

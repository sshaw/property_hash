# PropertyHash

Access a nested Ruby Hash using Java-style properties as keys.

## Usage

```rb
require "property_hash"
require "pp"

h = {
  :a => {
    :b => 1,
    :c => { :d => "DEEEE" },
    :x => 888,
    :y => [9999]
  },
  :b => {
    :zeee => 888
  }
}

ph = PropertyHash.new(h)

p ph["a.c.d"]  # DEEEE
p ph["b.zeee"] # 888

ph["a.c.x"] = "X"

pp ph.keys    # ["a.b", "a.c.d", "a.x", "a.y", "b.zeee", "a.c.x"]
pp ph.values  # [1, "DEEEE", 888, [9999], 888, "X"]

ph.each { |k, v| p k }
pp ph.to_h  # h but with :a => { :c => { :x => "X" } }
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "property_hash"
```

And then execute:

    bundle

Or install it yourself as:

    gem install property_hash

## See Also

- [JavaProperties](https://github.com/jnbt/java-properties)
- [Localio](https://github.com/mrmans0n/localio)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

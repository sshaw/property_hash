require "minitest/spec"

describe PropertyHash do
  before do
    @hash = {
      :a => {
        :b => 1,
        :c => { :d => "DEEEE" },
        :d => 0xFF,
        :e => [1, 2]
      },
      :b => {
        :c => "CEEEE!"
      },
      :c => 1
    }
  end

  it "is Enumerable" do
    _(PropertyHash.new(@hash)).must_be_kind_of Enumerable
  end

  describe "#each" do
    it "returns each key/value pair" do
      ph = PropertyHash.new(@hash)

      keys = []
      vals = []

      # Use single arg to ensure we're passing in [k,v] like Hash
      ph.each do |kv|
        keys << kv[0]
        vals << kv[1]
      end

      _(keys).must_equal %w[
        a.b
        a.c.d
        a.d
        a.e
        b.c
        c
      ]

      _(vals).must_equal [
        1,
        "DEEEE",
        0xFF,
        [1, 2],
        "CEEEE!",
        1
      ]
    end
  end

  describe "#[]" do
    it "expands the property and returns the underlying value" do
      ph = PropertyHash.new(@hash)

      _(ph["c"]).must_equal 1
      _(ph["b.c"]).must_equal "CEEEE!"
      _(ph["a.b"]).must_equal 1
      _(ph["a.c.d"]).must_equal "DEEEE"
    end

    describe "when a key does not exist" do
      it "returns nil" do
        ph = PropertyHash.new(@hash)
        _(ph["does not exist"]).must_be_nil
      end
    end

    describe "when using a key location that is not an underlying Hash" do
      it "returns nil" do
        ph = PropertyHash.new(@hash)
        # a.b is an Integer and not a Hash. Ensure an error is not raised
        _(ph["a.b.c"]).must_be_nil
      end
    end
  end

  describe "#[]=" do
    it "expands the key and assigns it the underlying hash" do
      ph = PropertyHash.new(@hash)
      ph["x"] = 999

      _(ph.to_h[:x]).must_equal 999

      ph["a.c.d"] = "new dee"

      _(ph.to_h.dig(:a, :c, :d)).must_equal "new dee"
    end

    it "does not modify the hash used in initialization" do
      ph = PropertyHash.new(@hash)
      ph["x"] = 999

      _(@hash).wont_include("x")
    end
  end

  describe "#keys" do
    it "returns the underlying hash keys as flattened property strings" do
      ph = PropertyHash.new(@hash)

      _(ph.keys).must_equal %w[
        a.b
        a.c.d
        a.d
        a.e
        b.c
        c
      ]
    end

    describe "#values" do
      it "returns the underlying hash values" do
        ph = PropertyHash.new(@hash)

        _(ph.values).must_equal [
          1,
          "DEEEE",
          0xFF,
          [1, 2],
          "CEEEE!",
          1
        ]
      end
    end

    describe "#to_h" do
      it "returns a copy of the underlying hash" do
        ph = PropertyHash.new(@hash)
        copy = ph.to_h

        _(copy).must_equal @hash
        _(copy.object_id).wont_equal @hash.object_id
      end
    end
  end
end

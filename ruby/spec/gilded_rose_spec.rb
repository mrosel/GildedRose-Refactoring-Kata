require_relative '../spec_helper'

describe GildedRose do
  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0), Item.new("bar", 0, 0)]
      rose = GildedRose.new(items)
      rose.update_quality
      rose.items.each_with_index do |item, index|
        expect(item.name).to eq items[index].name
      end
    end
  end
end

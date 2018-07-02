require 'active_support/concern'
require_relative 'item'

class GildedRose
  attr_reader :items

  # TODO: These really belong to item and only the business logic here
  # comparison of strings == 'bad'
  SPECIAL_ITEMS_PROPERTY = {
    "Sulfuras, Hand of Ragnaros" => :legendary,
    "Conjured Mana Cake" => :conjured,
    "Aged Brie" => :collectable, # prices increase with time
    "Backstage passes to a TAFKAL80ETC concert" => :limited_event # prices increase with near event, worthless after
  }


  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      type = (SPECIAL_ITEMS_PROPERTY[item.name] || 'Normal').to_s.capitalize
      classname = type.to_s.split('_').map{|s| s.capitalize}.join
      Module.const_get("#{classname}Item").change(item)
    end
  end
end

class NormalItem
  def self.change(item)
    @item = item
    sell_in!
    quality!
  end

  def self.sell_in!
    @item.sell_in = @item.sell_in - 1
  end

  def self.quality!
    @item.quality = @item.quality - 1 unless @item.quality == 0
    # additional depreciation for sell in
    if @item.quality >= 1 && @item.sell_in < 0
      @item.quality = @item.quality - 1
    end
  end
end

# TODO: this makes more sense as a mixin rather than inheritence
class LimitedEventItem < NormalItem
end

class LegendaryItem < NormalItem
  def change(item)
  end
end

class ConjuredItem < NormalItem
end

class CollectableItem < NormalItem

end

require_relative 'item'
require_relative 'normal_item'
require_relative 'collectable_item'
require_relative 'legendary_item'
require_relative 'limited_event_item'
require_relative 'conjured_item'

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

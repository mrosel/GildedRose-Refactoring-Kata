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
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
end

class LimitedEventItem < NormalItem
end

class LegendaryItem < NormalItem
  # def self.change(item)

  # end
end


class ConjuredItem < NormalItem
  # def self.change(item)

  # end
end

class CollectableItem < NormalItem
  # def self.change(item)

  # end
end

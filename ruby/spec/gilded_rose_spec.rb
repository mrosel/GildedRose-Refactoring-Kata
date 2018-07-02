require_relative '../spec_helper'

describe GildedRose do
  let(:brie) { Item.new(name='Aged Brie', sell_in=2, quality=0) }
  let(:backstage_pass) {
      Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=15, quality=20)
    }
  let(:expired) { Item.new('expired', 0, 0) }
  let(:dexterity_vest) { Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20) }
  let(:elixir) { Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7) }
  let(:sulfuras) { Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80) }

  let(:items) {[
      expired,
      brie,
      backstage_pass,
      dexterity_vest,
      elixir,
      sulfuras
    ]}

  describe '#update_quality' do
    it 'does not change the name' do
      rose = GildedRose.new(items)
      rose.update_quality
      rose.items.each_with_index do |item, index|
        expect(item.name).to eq items[index].name
      end
    end
  end

  describe '#quality' do
    let(:rose) { GildedRose.new([expired]) }
    it 'Quality is never negative for all items' do
      rose.update_quality
      rose.items.each do |item|
        expect(item.quality).to be >= 0
      end
    end
  end

  context 'normal items' do
    let(:normal_items) { [expired, elixir, dexterity_vest] }
    describe '#sell_in' do
      let(:rose) { GildedRose.new(normal_items) }

      it 'Sell-in always decreases' do
        rose.items.each do |item|
          expect{ rose.update_quality }.to change{ item.sell_in }.by(-1)
        end
      end
    end

    describe '#quality' do
      let(:max_brie) { Item.new(name='Aged Brie', sell_in=2, quality=50) }
      let(:expired) { Item.new('expired', 0, quality=50) }

      # Clarification: an item can never have its Quality increase above 50 - but it can start above 50
      it 'Quality of an item is never "raised" more than 50' do
        rose = GildedRose.new([max_brie, expired])
        rose.update_quality
        rose.items.each do |item|
          expect(0..50).to cover(item.quality)
        end
      end

      # Once the sell by date has passed, Quality degrades twice as fast
      it 'Once the sell by date has passed, Quality degrades twice as fast' do
        rose = GildedRose.new([expired])
        rose.items.each do |item|
          expect{ rose.update_quality }.to change{ item.quality }.by(-2)
        end
      end
    end
  end

  context 'collectable' do
    # 'Aged Brie' actually increases in Quality the older it gets
    describe '#collectable' do
      let(:items) { [brie] }

      it 'Increases in quality' do
        pending('Increases in quality')
      end
    end
  end

  context 'Limited Events' do
    describe '#limited_event' do
      # 'Backstage passes', like aged brie, increases in Quality as its SellIn value approaches;
      # Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
      let(:items) { [backstage_pass]}

      it 'Increases in quality' do
        pending('Increases in quality')
      end

      # Quality drops to 0 after the concert
      it 'Worthless(0) after event' do
        pending('Worthless after event')
      end
    end
  end

  context 'Legendary Items' do
    describe '#legendary_items' do
      # 'Sulfuras', being a legendary item, never has to be sold or decreases in Quality
      it 'never has to be sold ' do
        # TODO: get clarification because all items decrease in sellin
        pending('Onever has to be sold ')
      end

      # Sulfuras starts with quality of 80 and it never alters.
      it 'never decreases in Quality' do
        pending('decreases in Quality')
      end
    end
  end

  context 'Conjured Items' do
    describe '#conjured' do
      # 'Conjured' items degrade in Quality twice as fast as normal items
      it 'degrade in Quality twice as fast as normal items' do
        pending('degrade in Quality twice as fast as normal items')
      end
    end
  end
end

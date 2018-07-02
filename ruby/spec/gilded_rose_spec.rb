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

  let(:collectables){ [brie, backstage_pass] }
  let(:legendary_items){ [sulfuras] }
  let(:conjured){ [Item.new(name="Conjured Mana Cake", sell_in=3, quality=6)] }

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

      # Once the sell by date has passed, Quality degrades twice as fast
      it 'Once the sell by date has passed, Quality degrades twice as fast' do
        rose = GildedRose.new([expired])
        rose.items.each do |item|
          expect{ rose.update_quality }.to change{ item.quality }.by(-2)
        end
      end
    end
  end

  context 'Acts as a Collectable' do
    let(:max_brie) { Item.new(name='Aged Brie', sell_in=2, quality=50) }

    # 'Aged Brie' actually increases in Quality the older it gets
    describe '#quality' do
      let(:items) { [brie] }
      let(:rose) { GildedRose.new(collectables) }

      it 'Increases in quality' do
        rose.items.each do |item|
          expect{ rose.update_quality }.to change{ item.quality }.by(1)
        end
      end

      # Clarification: an item can never have its Quality increase above 50 - but it can start above 50
      it 'Quality of an item is never "raised" more than 50' do
        rose = GildedRose.new([max_brie])
        rose.update_quality
        rose.items.each do |item|
          expect(0..50).to cover(item.quality)
        end
      end
    end
  end

  context 'Limited Events' do
    describe '#limited_event' do
      # 'Backstage passes', like aged brie, increases in Quality as its SellIn value approaches;
      let(:less_than_ten_days) { Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=9, quality=20) }
      let(:less_than_five_days) { Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=4, quality=20) }
      let(:event_ended) { Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=0, quality=20) }

      # TODO: move 'Increases in quality' to shared example
      # Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
      it 'Increases by 2 when there are less than 10 days' do
        rose = GildedRose.new([less_than_ten_days])
        expect{ rose.update_quality }.to change{ rose.items.first.quality }.by(2)
      end

      it 'Increases by 3 when there are less than 5 days' do
        rose = GildedRose.new([less_than_ten_days])
        expect{ rose.update_quality }.to change{ rose.items.first.quality }.by(3)
      end

      # Quality drops to 0 after the concert
      it 'Worthless(0) after event' do
        rose = GildedRose.new([event_ended])
        rose.update_quality
        expect(rose.items.first.quality).to eq 0
      end
    end
  end

  context 'Legendary Items' do
    let(:rose) { GildedRose.new(legendary_items) }

    describe '#legendary_items' do
      # 'Sulfuras', being a legendary item, never has to be sold or decreases in Quality
      it 'never has to be sold ' do
        # TODO: get clarification because all items decrease in sellin
        # what if started with negative?
        rose.items.each do |item|
          expect{ rose.update_quality }.not_to change{ item.sell_in }
        end
      end

      # Sulfuras starts with quality of 80 and it never alters.
      it 'never decreases in Quality' do
        rose.items.each do |item|
          expect{ rose.update_quality }.not_to change{ item.quality }
        end
      end
    end
  end

  context 'Conjured Items' do
    let(:rose) { GildedRose.new(conjured) }

    describe '#quality' do
      # 'Conjured' items degrade in Quality twice as fast as normal items
      it 'degrade in Quality twice as fast as normal items' do
        rose.items.each do |item|
          expect{ rose.update_quality }.to change{ item.quality }.by(-2)
        end
      end
    end
  end
end

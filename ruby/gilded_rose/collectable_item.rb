class CollectableItem < NormalItem
  MAX_INCREASE = 50
  def self.quality!
    @item.quality += 1 unless @item.quality >= MAX_INCREASE
  end
end

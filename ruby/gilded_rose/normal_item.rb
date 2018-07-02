class NormalItem
  QUALITY_DELTA = 1
  SELL_IN_DELTA = 1

  def self.change(item)
    @quality_delta ||= QUALITY_DELTA
    @item = item
    sell_in!
    quality!
  end

  def self.sell_in!
    @item.sell_in -= SELL_IN_DELTA
  end

  def self.quality!
    @item.quality -= @quality_delta unless @item.quality == 0
    # additional depreciation for sell in
    if @item.quality >= @quality_delta && @item.sell_in < 0
      @item.quality -= @quality_delta
    end
  end

  def self.worthless?
    @item.sell_in <= 0
  end
end

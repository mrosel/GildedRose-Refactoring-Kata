# TODO: this makes more sense as a mixin rather than inheritence
class LimitedEventItem < CollectableItem
  def self.quality!
    super

    return @item.quality = 0 if worthless?

    if @item.quality <= MAX_INCREASE
      @item.quality += 1 if @item.sell_in < 10
    end

    if @item.quality <= MAX_INCREASE
      @item.quality += 1 if @item.sell_in < 5
    end
  end
end
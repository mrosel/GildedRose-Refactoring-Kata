class ConjuredItem < NormalItem
  QUALITY_DELTA = 2
  def self.change(item)
    @quality_delta = QUALITY_DELTA
    super
  end
end
class GildedRose
  attr_reader :special_items

  def initialize(items)
    @items = items
    @special_items = [
      { name: "Aged Brie", decay_rate: -1 },
      { name: "Sulfuras", decay_rate: 0 },
      { name: "Backstage passes", decay_rate: -1 },
      { name: "Conjured", decay_rate: 2 }
    ]

    create_methods
  end

  def create_methods
    @special_items.each do |special_item|
      self.class.send(:define_method, "process_#{special_item[:name].downcase.gsub(" ","_")}") do |item, special_item|
        if special_item[:name] == "Backstage passes"
          case
          when item.sell_in.between?(6,10)
            special_item[:decay_rate] = -2
          when item.sell_in.between?(1,5)
            special_item[:decay_rate] = -3
          when item.sell_in <= 0
            special_item[:decay_rate] = item.quality
          end
        end

        decrease_quality(item, special_item)
        decrease_sell_in(item, special_item)
      end
    end
  end

  def decrease_quality(item, special_item)
    unless special_item[:decay_rate] < 0 && item.quality > 49 # never increase quality to more than 50
      item.quality = item.quality - special_item[:decay_rate] if item.quality > 0
    end
  end

  def decrease_sell_in(item, special_item)
    item.sell_in = item.sell_in - 1 if special_item[:name] != "Sulfuras"
    decrease_quality(item, special_item) if item.sell_in < 0 # degrade twice as fast after sell_in
  end

  def update_quality
    @items.each do |item|
      matches = @special_items.map do |special_item|
        if item.name.include?(special_item[:name])
          send("process_#{special_item[:name].downcase.gsub(" ", "_")}".to_sym, item, special_item)
          return true
        end
      end
      if !matches.include?(true)
        decrease_quality(item, {name: "Normal Item", decay_rate: 1})
        decrease_sell_in(item, {name: "Normal Item", decay_rate: 1})
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

require './gilded_rose'

Rspec.describe GildedRose do
  describe "#update_quality" do
    context "when item is not a special item" do
      item = Item.new("Normal Item", 1, 1)
      gilded_rose = GildedRose.new([item])
      gilded_rose.update_quality

      it "decreases the quality by 1" do
        expect(item.quality).to eq(0)
      end

      it "decreases the sell_in by 1" do
        expect(item.sell_in).to eq(0)
      end

      context "and sell_in has passed" do
        it "decreases the quality twice as fast" do
          item.quality = 4
          item.sell_in = 0
          gilded_rose.update_quality
          expect(item.quality).to eq(2)
        end
      end
    end

    context "when item is Aged Brie" do
      item = Item.new("Aged Brie", 1, 1)
      gilded_rose = GildedRose.new([item])
      gilded_rose.update_quality

      it "increases the quality by 1" do
        expect(item.quality).to eq(2)
      end

      it "never allows quality to go beyond 50" do
        item.quality = 50
        item.sell_in = 1
        gilded_rose.update_quality
        expect(item.quality).to eq(50)
      end

      it "decreases the sell_in by 1" do
        expect(item.sell_in).to eq(0)
      end

      context "and sell_in has passed" do
        it "increases the quality twice as fast" do
          item.quality = 4
          item.sell_in = 0
          gilded_rose.update_quality
          expect(item.quality).to eq(6)
        end
      end
    end

    context "when item is Sulfuras" do
      item = Item.new("Sulfuras", 1, 1)
      gilded_rose = GildedRose.new([item])
      gilded_rose.update_quality

      it "does not decrease quality" do
        expect(item.quality).to eq(1)
      end

      it "does not decrease sell_in" do
        expect(item.sell_in).to eq(1)
      end

      context "and sell_in has passed" do
        it "does not decrease quality" do
          item.quality = 4
          item.sell_in = 0
          gilded_rose.update_quality
          expect(item.quality).to eq(4)
        end
      end
    end

    context "when item is a Backstage pass" do

      context "and sell_in is less than 10" do
        item = Item.new("Backstage passes", 9, 1)
        gilded_rose = GildedRose.new([item])
        gilded_rose.update_quality

        it "increases the quality by 2" do
          expect(item.quality).to eq(3)
        end

        it "decreases the sell_in by 1" do
          expect(item.sell_in).to eq(8)
        end
      end

      context "and sell_in is less than 5" do
        item = Item.new("Backstage passes", 3, 1)
        gilded_rose = GildedRose.new([item])
        gilded_rose.update_quality

        it "increases the quality by 3" do
          expect(item.quality).to eq(4)
        end

        it "decreases the sell_in by 1" do
          expect(item.sell_in).to eq(2)
        end
      end

      context "and sell_in is less than or equal zero" do
        item = Item.new("Backstage passes", 0, 1234)
        gilded_rose = GildedRose.new([item])
        gilded_rose.update_quality

        it "drops the quality to zero" do
          expect(item.quality).to eq(0)
        end

        it "decreases the sell_in by 1" do
          expect(item.sell_in).to eq(-1)
        end

        it "does not allow quality to be negative" do
          gilded_rose.update_quality
          expect(item.quality).to eq(0)
        end
      end
    end

    context "when item is Conjured" do
      item = Item.new("Conjured", 10, 4)
      gilded_rose = GildedRose.new([item])
      gilded_rose.update_quality

      it "decreases the quality twice as fast" do
        expect(item.quality).to eq(2)
      end

      it "decreases the sell_in by 1" do
        expect(item.sell_in).to eq(9)
      end

      context "and sell_in has passed" do
        it "decreases the quality four times as fast" do
          item.quality = 4
          item.sell_in = 0
          gilded_rose.update_quality
          expect(item.quality).to eq(0)
        end
      end
    end

  end
end

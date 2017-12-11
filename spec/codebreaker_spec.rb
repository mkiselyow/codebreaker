require 'spec_helper'
require 'faker'


RSpec.describe Codebreaker do
  describe Codebreaker::Game do
    before(:each) do  
      Faker::UniqueGenerator.clear
    end

    describe Codebreaker::Game do
      let(:game) { @game = described_class.new('test') }

      it 'Game.new.start generates 4 digit number' do 
        game.start
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'digits are numbers from 1 to 6' do 
        game.start
        game.instance_variable_get(:@secret_code).each do |digit|
          expect(digit).to be_between(1, 6).inclusive
        end
      end

      it 'lets user input with Attempt.new' do
        valid_input = []
        4.times { valid_input << Faker::Number.unique.between(1, 6)}
        game.try_to_guess(valid_input)
        expect(game.attempts.size).to eq(1)
      end

      it "raises error if input in not valid" do
        msg = "=== GIVE ME 4 DIGITS (1-6) ==="
        invalid_input_array = [7543, 12345, 123, 'abcd']
        invalid_input_array.each do |invalid_input|
          expect { game.try_to_guess(7543) }.
            to raise_error(ArgumentError, msg)
        end
      end

      it "saves secret code" do 
        expect { game.start }.to change(game, :secret_code)
      end

      it "ends when attempts_count > 4" do 
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        expect { 4.times {game.try_to_guess(1235)} }.to raise_error(described_class::GameEnded)
      end

      it "creates hint if did not guess" do
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        expect { game.try_to_guess(1235) }.
          to change(game, :hints) #.from([]).to([Codebreaker::Hint.new(['+','+','+'])])
      end

      it "congradulates when win" do 
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        msg = "YOU win THE GAME, THE GAME IS ENDED"
        expect { game.try_to_guess(1234) }.to raise_error(described_class::GameEnded, msg)
      end

    end
  end

  it 'has a version number' do
    expect(Codebreaker::VERSION).not_to be nil
  end
end

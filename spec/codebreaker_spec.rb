require 'spec_helper'
require 'faker'


RSpec.describe Codebreaker do
  describe Codebreaker::Game do
    before(:each) do  
      Faker::UniqueGenerator.clear
    end

    describe '#start' do
      let(:game) { @game = described_class.new }

      it 'saves secret code' do
        game.start
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      # it 'saves 4 numbers secret code'

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
        expect(game.attempts_count).to eq(1)
      end

      it "raises" do
        expect { Object.new.foo }.to raise_error(NameError)
      end
      
    end
  end

  it 'has a version number' do
    expect(Codebreaker::VERSION).not_to be nil
  end
end

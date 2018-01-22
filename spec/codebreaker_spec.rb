require 'spec_helper'
require 'faker'


RSpec.describe Codebreaker do
  describe Codebreaker::Game do

    describe Codebreaker::Game do
      let(:game) { @game = described_class.new('test') }

      it 'Game.new.start generates 4 digit number' do 
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'digits are numbers from 1 to 6' do 
        game.instance_variable_get(:@secret_code).each do |digit|
          expect(digit).to be_between(1, 6).inclusive
        end
      end

      it 'lets user input with Attempt.new' do
        valid_input = []
        4.times { valid_input << Faker::Number.between(1, 6)}
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
        expect { 4.times {game.try_to_guess(1235)} }.to raise_error(ArgumentError)
      end

      it "creates hint if did not guess" do
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        expect { game.try_to_guess(1235) }.
          to change(game, :hints) #.from([]).to([Codebreaker::Hint.new(['+','+','+'])])
      end

      it "also compares positions of digits" do 
        game.instance_variable_set(:@secret_code, [1, 2, 4, 3])
        msg = "YOU win THE GAME, THE GAME IS ENDED"
        expect { game.try_to_guess(1234) }.not_to raise_error(ArgumentError, msg)
      end

      it "congradulates when win" do 
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        msg = "YOU win THE GAME, THE GAME IS ENDED"
        expect { game.try_to_guess(1234) }.to raise_error(ArgumentError, msg)
      end

      describe Codebreaker::Console do
        describe '#new_input' do 
          before do
            io_obj = double
            expect(subject)
              .to receive(:gets)
              .and_return(io_obj)
            expect(io_obj)
              .to receive(:chomp)
              .and_return("1234")
          end

          it "Console takes input" do
            subject.new_input
            expect(subject.instance_variable_get(:@input)).to eq "1234"
            # fake_stdin("foobar") do 
            #   input = gets.to_s.chomp.strip
            #   input.should == "foobar"
            # end
            # a = Codebreaker::Console.new
            # allow(a.new_input).to receive('1234')
            # expect(a.input).to eq('1234')
            # console = Codebreaker::Console.new
            # expect {Codebreaker::Console.new.stub(:gets).and_return('1234') }.to change(console, :input).from(nil).to('1234')
          end
        end
      end

    end
  end

  it 'has a version number' do
    expect(Codebreaker::VERSION).not_to be nil
  end
end

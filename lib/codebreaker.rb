require_relative "./codebreaker/version"
require "faker"


module Codebreaker
  SECRET_CODE_LENGTH = 4
  class Game
    attr_accessor :secret_code, :attempts, :win_or_lose, :hints
    def initialize
      #load game history method
      start
      @attempts = []
      @hints = []
      @attempts_count_limit = 4
      @win_or_lose = 'lose'
    end

    def start
      @secret_code = []
      Faker::UniqueGenerator.clear
      4.times { @secret_code << Faker::Number.unique.between(1, 6)}
    end

    def try_to_guess(attempt_to_guess)
      current_attempt = Attempt.new(attempt_to_guess)
      @attempts << current_attempt
      compare_user_input_with_secret_code(current_attempt.user_input)
    end

    private

      def count_of_attempts_does_not_exceed_limit
        @attempts_count_limit > @attempts.size
      end

      def compare_user_input_with_secret_code(current_attempt_user_input)
        right_digits = []
        current_attempt_user_input.map do |digit|
          right_digits << '+' if @secret_code.include?(digit.to_i)
        end
        if right_digits.compact.size == SECRET_CODE_LENGTH
          @win_or_lose = 'win'
          raise GameEnded.new(@win_or_lose)
        elsif count_of_attempts_does_not_exceed_limit
          @hints << Hint.new(right_digits)
        else
          raise GameEnded.new(@win_or_lose)
        end
      end

    class GameEnded < StandardError
      def initialize(win_or_lose="The Game is ended")
        super("YOU #{win_or_lose} THE GAME, THE GAME IS ENDED")
        #save game history method
      end
    end
  end

  class Attempt
    attr_reader :user_input
    def initialize(user_input)
      @user_input = user_input.to_s.split('') if valid?(user_input)
    end

    private

      def valid?(user_input)
        msg = "=== GIVE ME 4 DIGITS (1-6) ==="
        user_input = user_input.to_s.split('') if !user_input.is_a?(Array) 
        user_input.join.match(/([1-6]){4}/) ? true : (raise ArgumentError.new(msg))
      end
  end

  class Hint
    attr_reader :result
    def initialize(right_digits)
      (SECRET_CODE_LENGTH - right_digits.compact.size).times { right_digits << '-'}
      @result = right_digits
    end
  end
end
require_relative "./codebreaker/version"
require "faker"


module Codebreaker
  class Game
    attr_accessor :secret_code, :attempts_count
    def initialize
      @secret_code = :start
      @attempts_count = 0
    end

    def start
      @secret_code = []
      Faker::UniqueGenerator.clear
      4.times { @secret_code << Faker::Number.unique.between(1, 6)}
    end

    def try_to_guess(attempt_to_guess)
      @attempts_count += 1 if Attempt.new(attempt_to_guess)
      #if you won
      #if you lose
      #if attemps count > 4
    end
  end

  class Attempt
    attr_reader :attempt_to_guess
    def initialize(attempt_to_guess)
      @attempt_to_guess = attempt_to_guess.to_s if valid?(attempt_to_guess)
    end

    def valid?(attempt_to_guess)
      msg = "=== GIVE ME 4 DIGITS (1-6) ==="
      attempt_to_guess = attempt_to_guess.to_s.split('') if !attempt_to_guess.is_a?(Array) 
      attempt_to_guess.join.match(/([1-6]){4}/) ? true : (raise ArgumentError.new(msg))
    end
  end

  class Hint
    attr_reader :result
    def initialize(attempt_to_guess_validated)
      @result = analize(attempt_to_guess_validated)
    end

    def analize(attempt_to_guess_validated)
      #
    end
  end
end

module Codebreaker
  SECRET_CODE_LENGTH      = 4
  GAMES_HISTORY_FILE_PATH = 'lib/history.txt'
  WINNING_COMBINATION = %w(+ + + +)
  class Game
    attr_accessor :secret_code, :attempts, :is_this_winning_game, :hints, :this_is_a_test, :attempts_count_limit, :history
    def initialize(this_is_a_test = nil )
      start
      @attempts = []
      @hints = []
      @attempts_count_limit = 4
      @is_this_winning_game = false
      @this_is_a_test = this_is_a_test
      @history = Codebreaker::History.new
      # user
    end

    def is_this_winning_game?
      @is_this_winning_game
    end

    def start
      @secret_code = []
      4.times { @secret_code << Faker::Number.between(1, 6)}
    end

    def try_to_guess(attempt_to_guess)
      current_attempt = Attempt.new(attempt_to_guess)
      self.attempts << current_attempt
      compare_user_input_with_secret_code_and_give_repond(current_attempt.user_input)
    end

    private

      def count_of_attempts_does_not_exceed_limit
        attempts_count_limit > attempts.size
      end

      def compare_user_input_with_secret_code_and_give_repond(current_attempt_user_input)
        hint = Respond.new(current_attempt_user_input, secret_code).hint
        if hint == WINNING_COMBINATION
          history.save_game_to_history(self)
          is_this_winning_game = true
          end_of_the_game(is_this_winning_game)
        elsif count_of_attempts_does_not_exceed_limit
          hints << hint
        else
          history.save_game_to_history(self) unless 
          end_of_the_game(is_this_winning_game)
        end
      end

      def end_of_the_game(is_this_winning_game)
        win_or_lose = is_this_winning_game ? 'win' : 'lose'
        raise ArgumentError.new("YOU #{win_or_lose} THE GAME, THE GAME IS ENDED")
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
        user_input = user_input.to_s.split('') unless user_input.is_a?(Array)
        user_input.join.match(/([1-6]){4}/) ? true : (raise ArgumentError.new(msg))
      end
  end

  class Respond
    attr_accessor :hint, :secret_code, :current_attempt_user_input
    def initialize(current_attempt_user_input, secret_code)
      @current_attempt_user_input = current_attempt_user_input
      @hint = []
      @secret_code = secret_code
      create_hint
    end

    private

      def create_hint
        current_attempt_user_input.each_with_index do |digit, index|
          if digit_belongs_to_secret_code?(digit) &&
            digit_position_is_the_same_as_in_the_secret_code?(digit, index)
              hint << '+'
          elsif digit_belongs_to_secret_code?(digit)
            hint << '-'
          else
            hint << nil
          end
        end
        hint.compact!
      end

      def digit_position_is_the_same_as_in_the_secret_code?(digit, index)
        secret_code[index] == digit.to_i ? true : false
      end

      def digit_belongs_to_secret_code?(digit)
        secret_code.include?(digit.to_i) ? true : false    
      end
  end

  class History
    attr_accessor :played_games, :current_error
    def initialize
      load_history
      @current_error = ''
    end

    def save_game_to_history(game)
      played_games << game
      File.open(GAMES_HISTORY_FILE_PATH, 'w'){|f| f.write(Marshal.dump(played_games)) }
    end

    def load_history
      begin
        self.played_games = Marshal.load(File.read(GAMES_HISTORY_FILE_PATH))
      rescue ArgumentError => e
        self.played_games = []
        self.current_error = e
      end
    end
  end

  class Console
    attr_accessor :input
    def initialize
      @input = nil 
    end

    def new_input
      self.input = gets.chomp
    end
  end
end
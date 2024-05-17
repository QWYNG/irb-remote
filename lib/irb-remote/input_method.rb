# frozen_string_literal: true

require_relative 'completor'

module IrbRemote
  class InputMethod < IRB::RelineInputMethod
    def initialize(binding)
      super(IrbRemote::Completor.new)
      @binding = binding
      Reline.completion_proc = lambda { |target, preposing, postposing|
        @completion_params = [preposing, target, postposing, @binding]
        @completor.completion_candidates(preposing, target, postposing, bind: @binding)
      }

      @scanner = RubyLex.new
      # TODO
      # https://github.com/ruby/irb/blob/66318d0a343552715f214f07c57bc4a60552ccfd/lib/irb.rb#L1166
      # I want to handle proc in druby in a nice way.
      undef :dynamic_prompt
    end

    def prompt=(_)
      @prompt = 'irb-remote> '
    end

    # TODO
    # https://github.com/ruby/irb/blob/66318d0a343552715f214f07c57bc4a60552ccfd/lib/irb.rb#L1166
    # I want to handle proc in druby in a nice way.
    # Currently, I'm copying and pasting the proc as it is set by irb.
    def check_termination
      @check_termination_proc = proc do |code|
        if Reline::IOGate.in_pasting?
          rest = @scanner.check_termination_in_prev_line(code, local_variables: @binding.local_variables)
          if rest
            Reline.delete_text
            rest.bytes.reverse_each do |c|
              Reline.ungetc(c)
            end
            true
          else
            false
          end
        else
          _tokens, _opens, terminated = @scanner.check_code_state(code, local_variables: @binding.local_variables)
          terminated
        end
      end
    end

    # TODO
    # https://github.com/ruby/irb/blob/66318d0a343552715f214f07c57bc4a60552ccfd/lib/irb.rb#L1203
    # I want to handle proc in druby in a nice way.
    # Currently, I'm copying and pasting the proc as it is set by irb.
    def auto_indent
      @auto_indent_proc = proc do |lines, line_index, byte_pointer, is_newline|
        next nil if lines == [nil]
        next nil if !is_newline && lines[line_index]&.byteslice(0, byte_pointer)&.match?(/\A\s*\z/)

        code = lines[0..line_index].map { |l| "#{l}\n" }.join
        tokens = RubyLex.ripper_lex_without_warning(code, local_variables: @binding.local_variables)
        @scanner.process_indent_level(tokens, lines, line_index, is_newline)
      end
    end
  end
end

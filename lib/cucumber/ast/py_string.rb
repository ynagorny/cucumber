module Cucumber
  module Ast
    # Represents an inline argument in a step. Example:
    #
    #   Given the message
    #     """
    #     I like
    #     Cucumber sandwich
    #     """
    #
    # The text between the pair of <tt>"""</tt> is stored inside a PyString,
    # which is yielded to the StepDefinition block as the last argument.
    #
    # The StepDefinition can then access the String via the #to_s method. In the
    # example above, that would return: <tt>"I like\nCucumber sandwich"</tt>
    #
    # Note how the indentation from the source is stripped away.
    #
    class PyString
      def initialize(string, quotes_indent)
        @string, @quotes_indent = string, quotes_indent
      end

      def to_s
        @string.indent(-@quotes_indent)
      end

      def accept(visitor, status)
        visitor.visit_py_string(to_s, status)
      end
      
      def arguments_replaced(arguments) #:nodoc:
        string = @string
        arguments.each do |name, value|
          string = string.gsub(name, value)
        end
        PyString.new(string, @quotes_indent)
      end
      
      # For testing only
      def to_sexp #:nodoc:
        [:py_string, to_s]
      end
                
    end
  end
end

module Effective
  module FormInputs
    class TextArea < Effective::FormInput

      def input_html_options
        { class: 'form-control', rows: 3 }
      end

    end
  end
end

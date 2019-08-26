module GraphqlDevise
  module Util
    module ClassGetter
      def self.call(class_string)
        class_string.constantize
      rescue NameError
        nil
      end
    end
  end
end

module Contracts
  module Eigenclass

    def self.extended(eigenclass)
      return if eigenclass.respond_to?(:owner_class=)

      class << eigenclass
        attr_accessor :owner_class
      end
    end

    def self.lift(base)
      return NullEigenclass if base.singleton_class?

      eigenclass = base.singleton_class

      unless eigenclass.respond_to?(:owner_class=)
        eigenclass.extend(Eigenclass)
      end

      unless eigenclass.respond_to?(:pop_decorators)
        eigenclass.extend(MethodDecorators)
        eigenclass.send(:include, Contracts)
      end

      eigenclass.owner_class = base

      eigenclass
    end

    module NullEigenclass
      def self.owner_class
        self
      end

      def self.pop_decorators
        []
      end
    end

  end
end

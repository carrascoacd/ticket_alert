module TicketAlert

  class DependencyInjector
    include Singleton

    def initialize
      @dependencies = {}
    end

    def inject klass
      @dependencies[klass]
    end

    def register object
      @dependencies[object.class] = object
    end

  end

end
require 'some_class'

class AdaptorOne
  def initialize
    @adaptee = SomeClass.new
    @adaptee.methods.select { |m| m =~ /work.*/}.each do |m|
      self.class.class_eval do
        define_method "sc_#{m}" do
          puts 'Work it!'
          @adaptee.send(m)
        end
      end
    end
  end
end

class AdaptorTwo
  def initialize
    @adaptee = SomeClass.new
  end

  def method_missing(m, *args)
    md = m.to_s.match(/sc_(work.*)/)
    if md && @adaptee.methods.include?(md[1].to_sym)
      puts 'Work it!'
      @adaptee.send(md[1])
    else
      super
    end
  end
end

class AdaptorThree
  def initialize
    @adaptee = SomeClass.new
  end

  def method_missing(m, *args)
    md = m.to_s.match(/sc_(work.*)/)
    if md && @adaptee.methods.include?(md[1].to_sym)
      self.class.class_eval do
        define_method m do
          puts 'Work it!'
          @adaptee.send(md[1])
        end
      end
      self.send(m)
    else
      super
    end
  end
end
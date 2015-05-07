module MyAttr
  module ClassMethods
    def my_attr(attribute)
      define_method(attribute) { instance_eval("@#{attribute}") }
      define_method("#{attribute}=") do |value|
        instance_eval("@#{attribute} = #{value}")
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
  end
end

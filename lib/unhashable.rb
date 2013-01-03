class Unhashable < Hash
  
  protected 
  def unhash!
    each do |k,v|
      k = methodize k.to_s

      if v.is_a?(Array)
        v = v.map { |item| Unhashable.new.unhash(item) }
        k = k.pluralize
      end
      
      v = Unhashable.new.unhash(v) if v.is_a?(Hash)
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
    end
  end

  private
  def methodize str=''
    str.scan(/[a-z]+/i).join("_").downcase rescue ''
  end
end
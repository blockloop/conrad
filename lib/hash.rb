require_relative 'string.rb'

class Hash

  def symbolize_keys
    h = {}
    self.each do |k, v| 
      v = v.symbolize_keys if v.is_a?(Hash)
      h[:"#{k.methodize}"] = v 
    end
    h
  end

end
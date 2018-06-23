class GameState
  @@state = {}

  def self.set_state(state = {})
    state.each do |k, v|
      @@state[k] = v

      if !self.class.methods.include? k
        self.define_singleton_method(k) do
          return @@state[k]
        end
      end
    end
  end

  def self.method_missing(method)
    return nil
  end

  def self.state
    @@state
  end

end

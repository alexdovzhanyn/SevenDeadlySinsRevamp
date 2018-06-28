class GameState
  @@state = {}
  @@listeners = []

  def self.set_state(state = {})
    state.each do |k, v|
      @@state[k] = v

      if !self.class.methods.include? k
        self.define_singleton_method(k) do
          return @@state[k]
        end
      end

      self.notify_listeners
    end
  end

  def self.method_missing(method)
    return nil
  end

  def self.state
    @@state
  end

  def self.subscribe(instance, callback)
    @@listeners << { i: instance, c: callback }
  end

  def self.notify_listeners
    @@listeners.each do |listener|
      listener[:i].public_send(listener[:c], @@state)
    end
  end
end

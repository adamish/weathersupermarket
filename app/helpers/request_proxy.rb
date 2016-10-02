class RequestProxy
  def initialize(target)
    @queue = Hash.new
    @queue_lock = Mutex.new
    @target = target
  end

  def get_current_request(key)
    @queue[key]
  end

  def wait_for_request(request)
    if Thread.current.object_id != request[:thread]
      request[:thread].join
    end
    self.remove_request(request)
  end

  def remove_request(request)
    @queue.delete request[:key]
  end

  def save_request(key)
    new_request = {key: key,thread: Thread.current }
    @queue[key] = new_request
    new_request
  end

  def request(key)
    current_request = nil
    new_request = nil
    @queue_lock.synchronize do
      current_request = self.get_current_request(key)
      if current_request == nil
        new_request = self.save_request(key)
      end
    end
    if current_request != nil
      Rails.logger.info "Request in progress for #{key}. Waiting..."
      self.wait_for_request(current_request)
      result = current_request[:result]
    else
      begin
        result = @target.request(key)
        new_request[:result] = result
      rescue Exception => e
        new_request[:result] = nil
        raise e
      ensure
        @queue_lock.synchronize do
          self.remove_request(new_request)
        end
      end
    end

    result
  end

end

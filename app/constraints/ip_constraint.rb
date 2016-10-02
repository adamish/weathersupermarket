class IpConstraint
  # true means reject
  def self.matches?(request)
    Rails.logger.info "Request from #{request.remote_ip}"
    ! (request.remote_ip == '75.119.214.199' || request.remote_ip == '127.0.0.1')
  end
end
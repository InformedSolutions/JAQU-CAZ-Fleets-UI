module StringCountHelper
  def body_scan(message)
    response.body.scan(message).size
  end
end

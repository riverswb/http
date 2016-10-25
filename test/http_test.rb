require 'minitest/autorun'
require 'minitest/emoji'
require './lib/http'

class HttpTest < Minitest::Test

  def test_http_exists
    skip
    assert Http.new
  end

  def test_request_response
    assert Http.new.request_response
  end

end

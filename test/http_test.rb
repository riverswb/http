require 'minitest/autorun'
require 'minitest/emoji'
require './lib/http'

class HttpTest < Minitest::Test

  def test_http_exists
    assert Http.new
  end

end

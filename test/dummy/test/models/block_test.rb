require "test_helper"

class BlockTest < ActiveSupport::TestCase
  def block
    @block ||= Block.new
  end

  def test_valid
    assert block.valid?
  end
end

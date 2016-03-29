require "test_helper"

class BlocksControllerTest < ActionController::TestCase
  def block
    @block ||= blocks :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:blocks)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference("Block.count") do
      post :create, block: { depth: block.depth, height: block.height, name: block.name, width: block.width }
    end

    assert_redirected_to block_path(assigns(:block))
  end

  def test_show
    get :show, id: block
    assert_response :success
  end

  def test_edit
    get :edit, id: block
    assert_response :success
  end

  def test_update
    put :update, id: block, block: { depth: block.depth, height: block.height, name: block.name, width: block.width }
    assert_redirected_to block_path(assigns(:block))
  end

  def test_destroy
    assert_difference("Block.count", -1) do
      delete :destroy, id: block
    end

    assert_redirected_to blocks_path
  end
end

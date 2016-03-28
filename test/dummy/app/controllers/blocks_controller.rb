class BlocksController < ApplicationController
  before_action :set_block, only: [:show, :edit, :update, :destroy]

  # GET /blocks
  def index
    @blocks = Block.order('lower(name)').all
    respond_to do |format|
      format.html
      format.json { render json: @blocks }
    end
  end

  # GET /blocks/1
  def show
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: @block }
    end
  end

  # GET /blocks/new
  def new
    @block = Block.new
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: @block }
    end
  end

  # GET /blocks/1/edit
  def edit
    render layout: false
  end

  # POST /blocks
  def create
    @block = Block.new(block_params)

    respond_to do |format|
      if @block.save
        format.html { redirect_to @block }
        format.json { render json: @block, status: :created }
        format.js
      else
        format.html { render :new }
        format.json { render json: @block.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /blocks/1
  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @block }
        format.json { head :no_content }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @block.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /blocks/1
  def destroy
    respond_to do |format|
      if @block.destroy    
        format.html { redirect_to blocks_url }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to blocks_url }
        format.json { render json: @block.errors, status: :forbidden }
        format.js { render status: :forbidden }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def block_params
      params.require(:block).permit(:name, :width, :height, :depth)
    end
end

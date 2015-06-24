class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]

	def index
    if params[:category].blank?
      @pins = Pin.all.order("created_at DESC")
    else
      @category_id = Category.find_by(name: params[:category]).id
      @pins = Pin.where(category_id: @category_id).order("created_at DESC")
    end
	end

  def show
    @comments = Comment.where(pin_id: @pin)
  end

	def new
		@pin = current_user.pins.build
	end

	def create
		@pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to @pin, notice: "Succesfully created Post"
    else
      render 'new'
    end
	end

  def edit
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: "Post was Succesfully updated!"
    else
      render 'edit'
    end
  end

  def destroy
    @pin.destroy
    redirect_to root_path
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

	private

	def pin_params
		params.require(:pin).permit(:title, :description, :image, :category_id)
	end

  def find_pin
    @pin = Pin.find(params[:id])
  end
end

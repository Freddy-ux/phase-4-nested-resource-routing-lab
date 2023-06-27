class ItemsController < ApplicationController
  before_action :find_user

  # GET /users/:user_id/items
  def index
    items = Item.includes(:user)
    render json: items.to_json(include: :user)
  end
  

  # GET /users/:user_id/items/:id
  def show
    item = @user.items.find_by(id: params[:id])
    if item
      render json: item
    else
      render json: { error: 'Item not found' }, status: :not_found
    end
  end

  # POST /users/:user_id/items
  def create
    user = User.find_by(id: params[:user_id])
    if user
      item = user.items.build(item_params)
      if item.save
        render json: item, status: :created
      else
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
  
  

  private

  def find_user
    @user = User.find_by(id: params[:user_id])
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end
end

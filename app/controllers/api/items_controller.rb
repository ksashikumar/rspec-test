class Api::ItemsController < ApiController
  @@items = []
  @@next_id = 1

  def index
    render json: @@items
  end

  def show
    item = @@items.find { |i| i[:id] == params[:id].to_i }
    if item
      render json: item
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def create
    item = { id: @@next_id, name: params[:name] }
    @@items << item
    @@next_id += 1
    render json: item, status: :created
  end

  def update
    item = @@items.find { |i| i[:id] == params[:id].to_i }
    if item
      item[:name] = params[:name] if params[:name]
      render json: item
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def destroy
    item = @@items.find { |i| i[:id] == params[:id].to_i }
    if item
      @@items.delete(item)
      head :no_content
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end
end 
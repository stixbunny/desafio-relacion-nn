class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:index, :empty_cart]

  def empty_cart
    @cart.destroy_all
    redirect_to orders_path, notice: 'Se ha vaciado el carro'
  end

  def index
    @total = @cart.inject(0) { |total, order| total += order.product.price * order.quantity }
  end

  def destroy
    @order = Order.find(params[:id])

    if @order.quantity == 1
      if @order.destroy
        redirect_to orders_path, notice: 'Carro actualizado'
      else
        redirect_to orders_path, alert: 'Error al actualizar el carro'
      end
    elsif @order.quantity > 1
      @order.quantity -= 1
      if @order.save
        redirect_to orders_path, notice: 'Carro actualizado'
      else
        redirect_to orders_path, alert: 'Error al actualizar el carro'
      end
    end
  end

  def create

    @previous_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)

    if @previous_order.present?
      new_quantity = @previous_order.quantity + 1
      @previous_order.update(quantity: new_quantity)
      redirect_to root_path, notice: "#{@previous_order.product.name} ha sido agregado al carro."
    else
      @order = Order.new()
      @product = Product.find(params[:product_id])
      @order.product = @product
      @order.user = current_user
      @order.price = @product.price

      if @order.save
        redirect_to root_path, notice: "#{@order.product.name} ha sido agregado al carro."
      else
        redirect_to root_path, alert: 'El producto NO ha sido agregado al carro.'
      end
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end

end

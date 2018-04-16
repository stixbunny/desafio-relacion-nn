class ProductsController < ApplicationController
  def index
    if params[:buscar].present?
      @products = Product.where('name like ?', "%#{params[:buscar].capitalize}%")
    else
      @products = Product.all
    end
  end
end

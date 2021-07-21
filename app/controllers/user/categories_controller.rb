class User::CategoriesController < ApplicationController
  def index
    @categorys = Category.all
  end
end

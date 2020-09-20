class ArticlesController < ApplicationController # ArticlesController inherits from ApplicationController
    def new
    end
    def create
        render plain: params[:article].inspect
    end
end

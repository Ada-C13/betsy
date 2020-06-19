class CategoriesController < ApplicationController
    # check that user is logged in before creating a category
    before_action :find_category, only:[:show]

    def show
    end

    def new
        @category = Category.new
    end
    
    def create
        @category = Category.create(category_params)

        if @category.save
            flash[:sucess] = "Successfully created category"
            redirect_to root_path
            return
        else
            flash.now[:error] = "Could not save category. Errors: #{@category.errors.messages}"
            render :new
            return
        end
    end

    # def edit  
    # end

    # def update
    #     # TODO: verify that category belongs to product with current user_id
    #     if @category.update(
    #         category_params
    #       )
    #         flash[:success] = "Category successfully edited"
    #         redirect_to root_path
            
    #         return
    #       else
    #         flash.now[:error] = "Unable to edit category. Errors: #{@category.errors.messages}"
    #         render :edit
    #         return
    #       end
    # end

    private

    def find_category
        @category = Category.find_by(id: params[:id])
        if @category.nil?
            head :not_found
            return
        end
    end

    def category_params
        return params.require(:category).permit(:name)
    end
end

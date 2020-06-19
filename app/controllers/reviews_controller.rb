class ReviewsController < ApplicationController

    # before_action :find_review, only:[:show, :edit]
    before_action :find_product
    before_action :is_merchant, except:[:show]

    # def show
    # end

    def new
        @review = Review.new
    end

    def create
        @review = Review.new(review_params)
        @review.product_id = @product.id

        if @review.save
            flash[:success] = "Successfully created review"
            redirect_to product_path(@product)
            return
        else
            flash.now[:error] = "Could not save review. Errors: #{@review.errors.messages}"
            render :new, status: :bad_request
            return
        end
    end

    # def edit
    # end

    # def update
    #     if @review.update(review_params)
    #         flash[:success] = "Review successfully edited"
    #         redirect_to root_path
    #         return
    #     else
    #         flash.now[:error] = "Unable to edit review. Errors: #{@review.errors.messages}"
    #         render :edit
    #         return
    #     end
    # end

    # def destroy
    #     if @review.nil?
    #         head :not_found
    #         return
    #     end

    #     @review.destroy
    #     flash[:success] = "Review successfully deleted"
    #     redirect_to root_path
    #     return
    # end

    private

    # def find_review
    #     @review = Review.find_by(id: params[:id])
    #     if @review.nil?
    #         head :not_found
    #         return
    #     end
    # end

    def find_product
        @product = Product.find_by(id: params[:product_id])
        if @product.nil?
            head :not_found
            return
        end
    end

    def is_merchant
        if @product.user.id == session[:user_id]
            flash[:error] = "Users cannot review their own product"
            redirect_to product_path(params[:product_id])
        end
    end

    def review_params
        return params.require(:review).permit(:rating, :text)
    end
end

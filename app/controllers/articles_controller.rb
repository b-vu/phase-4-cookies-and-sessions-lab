class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    if session[:page_views] == nil
      session[:page_views] = 1
    elsif session[:page_views] >= 3
      increment_page_views
      return render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    else
      increment_page_views
    end

    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def increment_page_views
    session[:page_views] += 1
  end
end

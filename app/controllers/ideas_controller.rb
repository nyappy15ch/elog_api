class IdeasController < ApplicationController
  def index
    category_name = params[:category_name]

    if Category.exists?(name: category_name) || category_name.blank?
      ideas = Category.finds_ideas(category_name) # 可動性向上と役割分担の観点から、アイデア取得のメソッドを作成しています。
      render json: { message: 'SUCCESS!', data: ideas }, status: :ok # status: :okがなくても200番が返されますが、可読性を上げるためあえて書いています。
    else
      render json: { message: "Category doesn't found" }, status: :not_found # ステータスコード404
    end
  end

  def create
    category = Category.find_or_create_by(name: params[:category_name])

    idea = Idea.new(idea_params(category))
    if idea.valid?
      idea.save
      render json: { message: 'SUCCESS!' }, status: :created # ステータスコード201
    else
      render json: { message: idea.errors.full_messages }, status: :unprocessable_entity # ステータスコード422
    end
  end

  private

  def idea_params(category)
    params.require(:idea).permit(:body).merge(category_id: category.id)
  end
end

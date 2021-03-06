class Category < ApplicationRecord
  has_many :ideas
  validates :name, presence: true, uniqueness: true

  def self.finds_ideas(category_name)
    # できるならば、アイデアモデルから取得できるよう修正したいです。（その方がより直感的に操作できると思うため）
    if category_name.present?
      Category.joins(:ideas).select('ideas.id, categories.name AS category, ideas.body').where(name: category_name)
    else
      Category.joins(:ideas).select('ideas.id, categories.name AS category, ideas.body')
    end
  end
end

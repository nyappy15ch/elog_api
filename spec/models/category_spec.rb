require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @category = FactoryBot.build(:category)
  end
  describe 'カテゴリー登録' do
    context 'カテゴリーが登録できる時' do
      it 'カテゴリー名が入っていれば登録できる' do
        expect(@category).to be_valid
      end
    end

    context 'カテゴリーが登録できない時' do
      it 'カテゴリー名がなければ登録できない' do
        @category.name = ''
        @category.valid?
        expect(@category.errors.full_messages).to include("Name can't be blank")
      end

      it 'カテゴリー名が重複していると登録できない' do
        @category.save
        another_category = FactoryBot.build(:category)
        another_category.valid?
        expect(another_category.errors.full_messages).to include('Name has already been taken')
      end
    end
  end
end

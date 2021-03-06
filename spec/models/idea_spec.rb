require 'rails_helper'

RSpec.describe Idea, type: :model do
  before do
    @idea = FactoryBot.build(:idea)
  end

  describe 'アイデア登録' do
    context 'アイデアが登録できる時' do
      it 'アイデアが入っていれば登録できる' do
        expect(@idea).to be_valid
      end
    end

    context 'アイデアが登録できない時' do
      it 'アイデアがなければ登録できない' do
        @idea.body = ''
        @idea.valid?
        expect(@idea.errors.full_messages).to include("Body can't be blank")
      end

      it 'カテゴリーが空欄だと登録できない' do
        @idea.category = nil
        @idea.valid?
        expect(@idea.errors.full_messages).to include('Category must exist')
      end

      it 'カテゴリーとアイデアが空欄だと登録できない' do
        @idea.category = nil
        @idea.body = ''
        @idea.valid?
        expect(@idea.errors.full_messages).to include('Category must exist',"Body can't be blank")
      end
    end
  end
end

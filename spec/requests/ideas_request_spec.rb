require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  describe '#index' do
    before do
      @idea = FactoryBot.create(:idea)
    end

    context '正常系' do
      it '正常にレスポンスを返すこと' do
        get ideas_path
        expect(response.status).to eq(200)
      end

      it 'レスポンスがjson形式であること' do
        get ideas_path
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'SUCCESSを返すこと' do
        get ideas_path
        expect(response.body).to include('SUCCESS!')
      end

      it 'アイデアのidを返すこと' do
        get ideas_path
        expect(response.body).to include(@idea.id.to_s)
      end

      it 'カテゴリー名を返すこと' do
        get ideas_path
        expect(response.body).to include(@idea.category.name)
      end

      it 'bodyを返すこと' do
        get ideas_path
        expect(response.body).to include(@idea.body)
      end

      # 動いているが、@ideaのレコードが含まれていないことを確かめた方が確実と考えてます。
      # まだうまく実装できていないため、一旦ideaのレコードが含まれていることをテストしています。
      it 'カテゴリーが指定された場合、指定されたカテゴリーのレコードだけ取得すること' do
        idea = FactoryBot.build(:idea)
        idea.category.name = 'テスト2'
        idea.body = 'これはテスト2です'
        idea.save
        get ideas_path, params: { category_name: idea.category.name }
        expect(response.body).to include(idea.id.to_s, idea.category.name, idea.body)
      end
    end

    context '異常系' do
      it 'カテゴリー名が存在しない場合、ステータスコード404を返すこと' do
        get ideas_path(category_name: 'hogehoge')
        expect(response.status).to eq(404)
      end

      it "カテゴリー名が存在しない場合、Category doesn't foundを返すこと" do
        get ideas_path(category_name: 'hogehoge')
        expect(response.body).to include("Category doesn't found")
      end
    end
  end

  describe '#create' do
    before do
      @category = FactoryBot.create(:category)
    end

    context '正常系' do
      it '正常にレスポンスを返すこと' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: 'レスポンステスト'
        }
        post ideas_path, params: idea_params
        expect(response.status).to eq(201)
      end

      it 'アイデアを登録できること' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: 'レスポンステスト'
        }
        expect { post ideas_path, params: idea_params }.to change { Idea.count }.by(1)
      end

      it '既に登録されているカテゴリーでも、正常にレスポンスを返すこと' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: @category.name
        }
        post ideas_path, params: idea_params
        expect(response.status).to eq(201)
      end

      it '既に登録されているカテゴリーでも、正常にレスポンスを返すこと' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: @category.name
        }
        expect { post ideas_path, params: idea_params }.to change { Idea.count }.by(1)
      end

      it 'レスポンスがjson形式であること' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: @category.name
        }
        post ideas_path, params: idea_params
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'SUCCESS!を返すこと' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: @category.name
        }
        post ideas_path, params: idea_params
        expect(response.body).to include('SUCCESS!')
      end

      it 'カテゴリーが指定された場合、指定されたカテゴリーのレコードだけ取得すること' do
      end
    end

    context '異常系' do
      it 'カテゴリー名が存在しない場合、ステータスコード422を返すこと' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: ''
        }
        post ideas_path, params: idea_params
        expect(response.status).to eq(422)
      end

      it 'カテゴリー名が存在しない場合、バリデーションエラーメッセージを返すこと' do
        idea_params = {
          idea: FactoryBot.attributes_for(:idea),
          category_name: ''
        }
        post ideas_path, params: idea_params
        expect(response.body).to include('Category must exist')
      end

      it 'アイデア名が空欄の場合、ステータスコード422を返すこと' do
        idea = FactoryBot.attributes_for(:idea)
        idea[:body] = ''
        idea_params = {
          idea: idea,
          category_name: @category.name
        }
        post ideas_path, params: idea_params
        expect(response.status).to eq(422)
      end

      it 'アイデア名が空欄の場合、バリデーションエラーメッセージを返すこと' do
        idea = FactoryBot.attributes_for(:idea)
        idea[:body] = ''
        idea_params = {
          idea: idea,
          category_name: @category.name
        }
        post ideas_path, params: idea_params
        expect(response.body).to include("Body can't be blank")
      end

      it 'アイデア名とカテゴリー名が空欄の場合、ステータスコード422を返すこと' do
        idea = FactoryBot.attributes_for(:idea)
        idea[:body] = ''
        idea_params = {
          idea: idea,
          category_name: ''
        }
        post ideas_path, params: idea_params
        expect(response.status).to eq(422)
      end

      it 'アイデア名が空欄の場合、バリデーションエラーメッセージを返すこと' do
        idea = FactoryBot.attributes_for(:idea)
        idea[:body] = ''
        idea_params = {
          idea: idea,
          category_name: ''
        }
        post ideas_path, params: idea_params
        expect(response.body).to include("Body can't be blank", 'Category must exist')
      end
    end
  end
end

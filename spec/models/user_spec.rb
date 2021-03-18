require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it 'nameとemail、passwordとpassword_confirmationが存在すれば登録できること' do
      expect(@user).to be_valid
    end

    it 'nameが空では登録できないこと' do
      @user.name = ''
      @user.valid? #処理にエラーがないかを確認するメソッド。この場合はエラーがある（nameが空で登録されるから）のでfalsになり、エラー文が表示される
      expect(@user.errors.full_messages).to include("Name can't be blank")
      #expectの引数に入っているのが15行目を実行した時に出るエラー文。このエラー文にincludeの引数が含まれていることを確認している。一致していればテスト完了
    end

    it 'emailが空では登録できないこと' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'passwordが空では登録できないこと' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'passwordが6文字以上であれば登録できること' do
      @user.password = '000000'
      @user.password_confirmation = '000000'
      expect(@user).to be_valid
    end

    it 'passwordが5文字以下であれば登録できないこと' do
      @user.password = '00000'
      @user.password_confirmation = '00000'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end

    it 'passwordとpassword_confirmationが不一致では登録できないこと' do
      @user.password = '123456'
      @user.password_confirmation = '1234567'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it '重複したemailが存在する場合登録できないこと' do
      @user.save
      another_user = FactoryBot.build(:user, email: @user.email)
      another_user.valid?
      expect(another_user.errors.full_messages).to include('Email has already been taken')
    end
  end
end
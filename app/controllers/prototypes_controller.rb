class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]#1
  before_action :move_to_index, only: [:edit]
#1 authenticate_user!の効果が:new, :edit, :destroyだけに出るように記述したがこれが間違い？

  def index
    @prototypes = Prototype.all #Prototypesで記述するのがおすすめ
                                #今回はここはallでOK！理由は＿prototypeのimage_tag(prototype.image）でimageを選択しているから
     
      #@prototypesの記述はindexのeachでprototypesテーブルから適したカラムを呼び出すため
      
      #0923発展実装の時は、ここに何かを紐付けしないとトップページで表示されない？
      #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
      #ここで定義されているものが各viewでも使える
  end
  
          #0922indexに全てのプロトタイプの情報を代入するとはどういうこと？ここにアクションがつながる様にすること？
          #情報がdbのことならモデルからAllで持ってくる？
           #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
           #設定次第、今回は上記の様に_prototypeで選択しているからallで大丈夫！
  def new
    @prototype = Prototype.new
  end

  def show #詳細ページ
   
    @prototype = Prototype.find(params[:id])#ここでテーブルからparamsの中の:idを引き出しているのでは？findでは無くincludes(:user)で固定する？
    @comment = Comment.new #こことview /showがつながるなんで？
    @comments = @prototype.comments
    #includes(:user)を使用する？N+1 問題が発生しているのか？
  end
      #Pathパラメータで送信されるID値で、Prototypeモデルの特定のオブジェクトを取得するように記述
      #というのは、なんのID値が欲しいのかまたPathパラメータは一意なソース例えばユーザーIDとかなんの値が欲しいのか
      #.find(params[:id])この形でテーブルからidを選んで表示してくれる今回何度もエラーが出たのは、Urlに引き出したidを入力していなかったらから
      #showの内容が見たければ、idを入力するただし、viewを繋ぐまで

  def create
    
    #保存機能は、createではなくnew・saveを使用するのが基本になる！
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path  #入力されたデータの保存先を指定できていない、わかっていない⇨⇨⇨⇨⇨⇨⇨⇨⇨prototypesテーブルとアクティブテーブルにCとMで制限をかけて保存される
                              #今回0920はまだパスは実装しなくて良いのでroot_pathを使用
                              #ここで入力されたデータをdbに入れたい⇨そのための保存機能
    else
      render :new
      #今回はnewでOK理由は、コントローラー内のアクションだから！
    end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])#ここで変数という箱を作ってidを探す
    if @prototype.update(prototype_params)#ここでストロングパラメーターでフィルターにかける
      redirect_to prototype_path
    else
      render :edit
    end  
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path #今回renderを使わないのは、renderの機能がviewアクションを通さないからredirect_toを使用する
  end
  
  private
          #ストロングパラメーターがここ！ストロングパラメーターの役割はコントローラーで制限をかける
          #バリデーションと少し似ている役割
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
        #9/22 requireがテーブル・permitがカラムと画像に制限をかける・mergeが誰が動作させたか！
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end


end

#＠を付けるとインスタンス変数になるそうするとviewでも使用可能になる
#rails routesでパスを見るときは、/00/id/のidがなんなのか考える
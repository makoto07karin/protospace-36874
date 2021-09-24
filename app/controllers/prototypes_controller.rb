class PrototypesController < ApplicationController
  def index
    @prototype = Prototype.all
    @prototypes = Prototype.all #Prototype.の後にはprototypeテーブルのカラムを入れる？
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

  def show
    @prototype = Prototype.find(params[:id])
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
      #今回はnewでOK
    end
  end

  private
          #ストロングパラメーターがここ！ストロングパラメーターの役割はコントローラーで制限をかける
          #バリデーションと少し似ている役割
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
        #9/22 requireがテーブル・permitがカラムと画像に制限をかける・mergeが誰が動作させたか！
  end
end

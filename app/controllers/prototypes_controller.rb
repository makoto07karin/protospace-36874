class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]#1
  before_action :move_to_index, only: [:edit]
#1 authenticate_user!の効果が:new, :edit, :destroyだけに出るように記述したがこれが間違い？

  def index
    @prototypes = Prototype.all
  end
    #Prototypesで記述するのがおすすめ
    #今回はここはallでOK理由は、全てのレコードをallでここに持ってきたいから
    #なぜここに持ってきたいのかというとviewである＿prototypeのimage_tag(prototype.image）で
    #レコード内の全てのimageカラムを取得したいから
    #@prototypesの記述は＠をつけることでviewでも使用可能になるから
    #そこから、indexのeachでprototypesテーブルから適したカラムを呼び出すため
  
  def new
    @prototype = Prototype.new
  end

  def show #詳細ページ
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new 
    @comments = @prototype.comments
  end
    #こことview /showがつながるなんで？
    #PrototypesControllerのviewの中にshowが記述されているから
    #Prototypeモデルから、何を持ってきているのか？
    #@prototype = Prototype.find(params[:id])でPrototypeテーブルのレコードを一つ取得している
    #それを記述しているのがfind(params[:id])
    #これがPrototypeのレコード一つ分の情報
    #なので、idが「１」の時は該当するレコードを１行を持ってくるので
    #viewではカラムを選んでいる


  def create
    
    #保存機能は、createではなくnew・saveを使用するのが基本になる！
    @prototype = Prototype.new(prototype_params)#prototype_paramsは引数としてプライベートから持ってきている
    if @prototype.save
      redirect_to root_path  #入力されたデータの保存先を指定できていない、わかっていない⇨⇨⇨⇨⇨⇨⇨⇨⇨prototypesテーブルとアクティブテーブルにCとMで制限をかけて保存される
                              #今回0920はまだパスは実装しなくて良いのでroot_pathを使用
                              #ここで入力されたデータをdbに入れたい⇨そのための保存機能
    else
      render :new
      #今回はnewでOK理由は、viewで返したいのはコントローラー内のアクションだから！
      #なので例えば他のコントローラー内のviewを指定すると別の記述が必要
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
        #ストロングパラメーターがモデル⇨カラムと順番に情報を保存していくのはわかるが最後のmerge(user_id: current_user.id)の意味は？
        #ここが課題の一つ
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end


end

#＠を付けるとインスタンス変数になるそうするとviewでも使用可能になる
#rails routesでパスを見るときは、/00/id/のidがなんなのか考える
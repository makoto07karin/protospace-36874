class CommentsController < ApplicationController
  def create
      #保存はできる様になったのでOK
      #ネストを使っているので、二つのパスが必要になる
      #
    @prototype = Prototype.find(params[:prototype_id])#1
    @comments = @prototype.comments#2

    @comment = Comment.new(comment_params)
    
    if @comment.save
      redirect_to prototype_path(@comment.prototype)
    else
      @prototype = Prototype.find(params[:prototype_id])
      render template: "prototypes/show"
      
    end 
    
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :user, :prototype).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end

#1
#別のコントローラーと繋がりたい時は、＠変数で定義すればOK？
#＠変数は大きい箱のイメージ！
#８行目が通ったのは、:prototype_idにしてから、
#今回は@prototypeという箱にモデルであるPrototypeからdbの情報が欲しい
#Prototype.find(params[:prototype_id])は定型分の一つと考える
#なのでここで無理に「user_id」などで欲しいデータを狭める必要はないよ！

#2 
#ここにshowの<% @comments.each do |comment| %>の@commentsか記述されている
#@commentsは、@prototypeという箱の:prototype_idで紐ずいたコメントが欲しいので自分の箱の中に入れた
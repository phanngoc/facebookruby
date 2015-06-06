
class BookController < ApplicationController
   protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
   def show
      #@book = Book.new;
      @title = "Hello title"
      @user = User.all;

   end
   def index
     if (!defined?(session[:user]) || session[:user].nil?)
       redirect_to  :controller=>"welcome",:action => "index" and return;
     end
      @position = "main"+params[:id];
      @usercurrent = User.find(session[:user]);
      @user = User.find(params[:id]);
      @posts = Post.where(["position = ?", @position]).order('time desc');
      usergroups = Usergroup.where(["id_user = ?", params[:id]]);
      a = []
      usergroups.each do |ug|
         a.push(Group.find(ug.id_group));
      end
      logger.debug "la gi:#{a}";
      @groups = a;

   end
   def showgroup
       if (!defined?(session[:user]) || session[:user].nil?)
         redirect_to  :controller=>"welcome",:action => "index" and return;
       end
      @usercurrent = User.find(session[:user]);
      userid = session[:user];
      @user = User.find(userid);
      usergroups = Usergroup.where(["id_user = ?", userid]);
      a = []
      usergroups.each do |ug|
         a.push(Group.find(ug.id_group));
      end
      @groups = a;

      id = "group"+params[:id];
      @position = id;
      @group = Group.find(params[:id]);
      @posts = Post.where(["position = ?",id]).order('time desc');

   end
   def postcomment
      content = params[:content];
      id_post = params[:id_post];
      userid = session[:user];
      comment = Comment.create(content: content,id_author:userid, id_post: id_post);
      logger.debug "la gi:#{comment}";
      redirect_to :back;
   end
   def postnew
     content = params[:content];
     position = params[:position];
     userid = session[:user];
     comment = Post.create(content: content,id_author:userid,position:position,time: Time.now.to_s(:db));
     logger.debug "la gi:#{comment}";
     redirect_to :back;
   end
end
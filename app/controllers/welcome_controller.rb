
class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  def index
    if (defined?(session[:user]))

    else
      logger.debug "index redirect welcome";
      redirect_to  :controller=>"book",:action => "index", :id => session[:user];
    end
  end
  def login
    if params[:username] == ''
      redirect_to :back,:flash => { :error => "Username not empty"};
      return;
    end
    if params[:password] == ''
      redirect_to :back,:flash => { :error => "Password not empty"};
      return;
    end
    @user = User.where(["username = ? and password = ?", params[:username],params[:password]]);
    if @user.count != 0
      logger.debug "la gi:#{@user.first.username}";
      session[:user] = @user.first.id;
      redirect_to  :controller=>"book",:action => "index", :id => @user.first.id;
    else
      redirect_to :back,:flash => { :error => "Username or password not correct"};
    end;
  end
  def register
    @user = User.where(["username = ?", params[:username]]);
    if @user.count != 0
      redirect_to :back,:flash => { :error_register => "Username is exist .Please choose new username"};
      return;
    end
    arr_date = params[:birthday].split('/');
    month = arr_date.at(0);
    day = arr_date.at(1);
    year = arr_date.at(2);
    user_inser = User.create(username:params[:username],password:params[:password],age:params[:age],gender:params[:gender],birthday:year+"-"+month+"-"+day+" 00:00:00");
    #logger.debug "id vua chen la:"+User.last.id;
    session[:user] = User.last.id;
    redirect_to  :controller=>"book",:action => "index", :id => User.last.id;
  end
  def logout
    session.delete(:user);
    redirect_to  :controller=>"welcome",:action => "index";
  end
  def addfriend
    Friend.create(id_me: session[:user],id_you:params[:id]);
    Friend.create(id_me: params[:id],id_you:session[:user]);
    redirect_to :back;
  end
  def addgroup
    Usergroup.create(id_user: session[:user],id_group:params[:id]);
    redirect_to :back;
  end
end
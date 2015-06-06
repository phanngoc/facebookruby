
class MessageController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  def index
    if (!defined?(session[:user]) || session[:user].nil?)
      redirect_to  :controller=>"welcome",:action => "index" and return;
    end
    @usercurrent = User.find(session[:user]);
    @userall = User.where(["id != ?",session[:user]]);
    userid = session[:user];
    @messages = Message.where(["(id_me = ? and id_you = ?) OR (id_you = ? and id_me = ?) ", userid,params[:id],userid,params[:id]]);
  end
  def newm
    if (!defined?(session[:user]) || session[:user].nil?)
      redirect_to  :controller=>"welcome",:action => "index" and return;
    end
    Message.create(id_me: session[:user],id_you:params[:id_you],message:params[:content]);
    redirect_to :back;
  end
end
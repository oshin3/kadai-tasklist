class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :update, :destroy]
    
  def index
    if logged_in?
      @tasks = current_user.tasks.build  # form_with 用
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
    else
      redirect_to login_url
    end
  end

  def show
  end

  def new
      @tasks = Task.new
  end

  def create
    @task = current_user.tasks.build(tasks_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:success] = 'Task が正常に追加されました'
      redirect_to root_url
    else
      @pagy, @task = pagy(current_user.tasks.order(id: :desc))
      flash.now[:danger] = 'Task が追加されませんでした'
      render 'index'
    end
  end

  def edit
  end

  def update
    if @tasks.update(tasks_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @tasks
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @tasks.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end

  private
  
  def set_task
    @tasks = Task.find(params[:id])
  end

  # Strong Parameter
  def tasks_params
    params.require(:task).permit(:content, :status)
  end
  
  # ユーザ確認
  def correct_user
    @tasks = current_user.tasks.find_by(id: params[:id])
    unless @tasks
      redirect_to root_url
    end
  end
  
end
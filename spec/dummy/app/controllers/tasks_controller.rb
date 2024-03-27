class TasksController < ApplicationController
  class Task
    include ActiveModel::Model

    attr_accessor :id, :name
  end

  TASKS = (1..51).map do |id|
    Task.new(
      id: id,
      name: "Task #{id}"
    )
  end

  def index
    @tasks = TASKS
    @task = TASKS.find { |t| t.id == params[:task_id] }
 end
end

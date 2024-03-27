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
    @task = TASKS.first
    @tasks = TASKS.filter { |task| task.name.include?(params[:task_search] || "")}
 end
end

class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :to_key
  attribute :id, :integer
  attribute :name, :string

  def model_name
    OpenStruct.new param_key: "user"
  end

  def self.find(id)
    new.tap do |user|
      user.to_key = [id]
      user.id = id
      user.name = "name"
    end
  end
end

class Department < ActiveRecord::Base

  # Validations
  validates :name, presence: true

  # Associations
  has_many :users
  has_one :picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::DepartmentPicture"

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> department.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(departments.name) LIKE LOWER('%#{query}%') OR LOWER(departments.description) LIKE LOWER('%#{query}%')")}

end

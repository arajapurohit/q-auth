FactoryGirl.define do
  factory :picture, :class => Image::DepartmentPicture do
    image { Rack::Test::UploadedFile.new('test/fixtures/test.jpg', 'image/jpg') }
    department
  end

  factory :department_picture, parent: :picture do
    association :imageable, :factory => :department
  end

  factory :designation_picture, parent: :picture do
    association :imageable, :factory => :designation
  end

  factory :user_picture, parent: :picture do
    association :imageable, :factory => :user
  end
end

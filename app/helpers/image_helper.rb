module ImageHelper

  def display_image(object, photo_association_name=:photo, width=80)

    if width.is_a?(String)
      if width.include?("px")
        width_val = width.split("px").first
      elsif width.include?("%")
        width_val = width.split("%").first
      else
        width_val = width.to_i
      end
      width_string = width
    else
      width_val = width
      width_string = "#{width.to_i}px"
    end

    if object.respond_to?(photo_association_name) && object.send(photo_association_name) && object.send(photo_association_name).persisted?
      return image_tag object.send(photo_association_name).image_url, :style=>"width:#{width_string};"
    else
      return image_tag "http://placehold.it/#{width_val}x#{width_val}", :style=>"width:#{width}"
    end
  end

  def display_photo(photo, width=100)
    return image_tag photo.image_url, :style=>"width:#{width}px;", :width=>"#{width}", :class=>""
  end

  def display_profile_picture(user, width=116, height=116, form=nil, classes=nil)
    classes = "mask-img-bdr-rounded" if classes.nil?
    if user && user.profile_picture.present?
      content_tag :div, :class=>classes, :style=>"width:#{width}px;height:#{height}px;" do
        image_tag user.profile_picture.image.thumb.url, :style=>"width:#{width}px;", :id=> display_profile_picture_id(user, form) ,:class => "profile" ,:alt => ''
      end
    else
      content_tag :div, :class=>classes, :style=>"width:#{width}px;height:#{height}px;" do
        image_tag "icons/default-user-116.png", :style=>"width:#{width}px;", :id => display_profile_picture_id(user, form),:alt => ''
      end
    end
  end

  def display_profile_picture_id(user, form=nil)
    (user && user.profile_picture.present?) ? "#{form}img_profile_picture_#{user.id}" : "#{form}img_uploaded_profile_picture"
  end

  ## Returns new photo url or edit existing photo url based on
  #  object is associated with photo or not
  # == Examples
  #   >>> upload_image_link(@user, admin_user_path(@user), :profile_picture)
  #   => "/admin/images/new" OR
  #   => "/admin/images/1/edit"
  def upload_image_link(object, redirect_url, photo_association_name=:photo)

    photo_object = nil
    photo_object =  object.send(photo_association_name) if object.respond_to?(photo_association_name)

    if photo_object.present?
      edit_admin_image_path(photo_object,
                                 :redirect_url => redirect_url,
                                 :imageable_id => object.id,
                                 :imageable_type => object.class.to_s,
                                 :image_type => photo_object.class.name)
    else
      photo_object = object.send("build_#{photo_association_name}")
      new_admin_image_path(:redirect_url => redirect_url,
                                 :imageable_id => object.id,
                                 :imageable_type => object.class.to_s,
                                 :image_type => photo_object.class.name)
    end
  end

  def upload_user_image_link(object, redirect_url, photo_association_name=:photo)

    photo_object = nil
    photo_object =  object.send(photo_association_name) if object.respond_to?(photo_association_name)

    if photo_object.present?
      edit_user_image_path(photo_object,
                                 :redirect_url => redirect_url,
                                 :imageable_id => object.id,
                                 :imageable_type => object.class.to_s,
                                 :image_type => photo_object.class.name)
    else
      photo_object = object.send("build_#{photo_association_name}")
      new_user_image_path(:redirect_url => redirect_url,
                                 :imageable_id => object.id,
                                 :imageable_type => object.class.to_s,
                                 :image_type => photo_object.class.name)
    end
  end

end

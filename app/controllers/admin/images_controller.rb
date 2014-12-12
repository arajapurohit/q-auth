class Admin::ImagesController < Admin::BaseController

  skip_before_filter :set_navs, :parse_pagination_params

  before_filter :get_user_Profile_picture, :only => [:edit, :update]

  before_filter :delete_pictures, :only => [:new, :edit]


  # GET /istadium_admin/images/new
  # GET /istadium_admin/images/new.json
  def new
    ## Intitializing the image object

    image_type = params[:image_type] || "Image::Base"

    @image = image_type.constantize.new

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @image }
      format.js {}
    end
  end

  # GET /istadium_admin/images/1/edit
  # GET /istadium_admin/images/1/edit.js
  # GET /istadium_admin/images/1/edit.json

  def edit
    ## Fetching the image object
    image_type = params[:image_type] || "Image::Base"
    @image = image_type.constantize.find(params[:id])
    respond_to do |format|
      # format.html { get_collections and render :index }
      # format.json { render json: @image }
      format.js {}
    end
  end

  # POST /istadium_admin/images/
  # POST /istadium_admin/images.js
  # POST /istadium_admin/images.json
  def create
    ## Creating the photo object
      ## Creating the image object
    image_type = params[:image_type] || "Image::Base"

    resource = params[:imageable_type].constantize.find params[:imageable_id]
    @image = image_type.constantize.new(image_params)

    # @photo = Photo::ProfilePicture.new(image_params)
    ## Setting redirect url
    @redirect_url = params[:redirect_url] || root_url

    ## Validating the data
    @image.imageable = resource

    respond_to do |format|

      if request.format.present? && request.format.symbol == :json
        delete_pictures
        @image.default_picture = false
      end
      if @image.save

        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Profile Picture")
        store_flash_message(message, :success)
        format.html {
          render :json => [@image.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@image.to_jq_upload].to_json
        }
      else
        # Setting the flash message
        message = @image.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        format.html { render action: "new" }
        format.js {render :template => "admin/images/new"}
      end
    end

  end

  # PUT /istadium_admin/images/1
  # PUT /istadium_admin/images/1.js
  # PUT /istadium_admin/images/1.json
  def update

    # Get the image object and assign new image path to it
    image_type = params[:image_type] || "Image::Base"
    @image = image_type.constantize.find(params[:id])

    if request.format.present? && request.format.symbol == :json
      @image.image = params[:image][:image]
    else
      @image.assign_attributes(image_params)
      @image.image.recreate_versions!
    end

    @redirect_url = params[:redirect_url] || root_url

    ## Validating the data
    @image.valid?

    respond_to do |format|
      if @image.errors.blank?
        # Saving the admin object
        @image.save

        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Image")
        store_flash_message(message, :success)

        format.html { redirect_to @redirect_url, notice: message }
        format.json { render :json => [@image.to_jq_upload].to_json }
        format.js {render js: "window.location.reload(true)"}
      else
        # Setting the flash message
        message = @image.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  def destroy_pictures
   delete_pictures
   render :json => true
 end

 private

 def delete_pictures
  # resource = Image::ProfilePicture.find(params[:id])
  @images = Image::ProfilePicture.where(:imageable_id => current_user.id, :imageable_type => "User", :default_picture => false)
  @images.delete_all
 end

 def get_user_Profile_picture
  @image = Image::ProfilePicture.find(params[:id])
 end

 def image_params
  params.require(:image).permit(:imageable_id, :imageable_type, :crop_x, :crop_y, :crop_w, :crop_h, :image)
 end

end

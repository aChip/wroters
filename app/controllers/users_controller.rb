class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
    
  #githubtest 
  # render new.rhtml
  def show
    @user = User.find(params[:id])
    @avatar = @user.avatar
    @locations = @user.locations
  end

  def edit
     validate_user(params[:id].to_i){return}
    @user = User.find(params[:id])

    @avatar = @user.avatar
    @locations = @user.locations
  end

  def set_avatar
#    current_user.avatar = Photo.find(params[:id])
    current_user.avatar_id = params[:id]
    current_user.save
    redirect_to :back

  end

  def new
    @user = User.new
  end

  def update
    if (current_user==nil) or (params[:id].to_i != current_user.id)  
      redirect_to '/'
      return
    end  

 
    
    @user = User.find(params[:id]) 

=begin
    @user.name = params[:user][:name]
    @user.sex = params[:user][:sex]
    @user.addr = params[:user][:addr]
    @user.tel = params[:user][:tel]
    @user.birth = params[:user][:birth]
    @user.save
=end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Album was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end

  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])

    success = @user && @user.save

    if success && @user.errors.empty?
      
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

end

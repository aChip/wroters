class FingersController < ApplicationController
  # GET /fingers
  # GET /fingers.xml
  def index

    @fingers = Finger.find_all_by_user_id(current_user)
    @user = current_user
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fingers }
    end
  end

  # GET /fingers/1
  # GET /fingers/1.xml
  def show
    @finger = Finger.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @finger }
    end
  end

  # GET /fingers/new
  # GET /fingers/new.xml
  def new 
    @finger = Finger.new
    @finger.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @finger }
    end
  end

  # GET /fingers/1/edit
  def edit
    @finger = Finger.find(params[:id])
    @finger.user = current_user
  end

  # POST /fingers
  # POST /fingers.xml
  def create
    @finger = Finger.new(params[:finger])
    @finger.user = current_user
    
    respond_to do |format|
      if @finger.save
        flash[:notice] = 'Finger was successfully created.'
        format.html { redirect_to(fingers_path) }
        format.xml  { render :xml => @finger, :status => :created, :location => @finger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @finger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fingers/1
  # PUT /fingers/1.xml
  def update
    @finger = Finger.find(params[:id])
    @finger.user = current_user
    respond_to do |format|
      if @finger.update_attributes(params[:finger])
        flash[:notice] = 'Finger was successfully updated.'
        format.html { redirect_to(fingers_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @finger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fingers/1
  # DELETE /fingers/1.xml
  def destroy
    @finger = Finger.find(params[:id])
    @finger.destroy

    respond_to do |format|
      format.html { redirect_to(fingers_url) }
      format.xml  { head :ok }
    end
  end


  def inlib
    finger_id = params[:id].to_i
    inlib=Win32API.new('fing','inlib',['i'],'i')
    inlib.call(finger_id)
    redirect_to :back
  end

  def outlib
    @finger = Finger.find(params[:id])
    @finger.status = nil
    @finger.save
    redirect_to :back
  end
end

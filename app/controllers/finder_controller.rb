class FinderController < ApplicationController
  def index
    @sphoto = Finger.find(params[:id]) 
    @source_id = params[:id].to_i
    @res =  find(params[:id].to_i)
    @r = @res.split
    @match_id=@r[0].to_i
    @sim=@r[1]
    if @match_id > 0
      @dphoto = Finger.find(@match_id)
      @user =  @dphoto.user
    end
  end

  def find(finger_id)
    finder=Win32API.new('fing','finder',['i'],'p')
    res = finder.call(finger_id)
    finder =nil
    res
  end

end

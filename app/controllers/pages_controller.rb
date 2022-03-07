class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :get_user

  def home
  end

  def profile
    @user = current_user
    @user_id_arr = []
    @user_id = @user.id
    @user_id_arr << @user_id

    # @friends = (Friendship.all.where(status: "accepted").where(requester_id: @user.id).or(Friendship.all.where(status: "accepted").where(receiver_id: @user.id)))

    # @receiving_friends_id = @friends.map(&:receiver_id)
    # @requesting_friends_id = @friends.map(&:requester_id)
    # @everyone_id = (@user_id_arr + @receiving_friends_id + @requesting_friends_id).uniq

    @user_posts = Post.where(user_id: @user_id)
    @user_reposts = Repost.where(user_id: @user_id)

    @profile_posts = @user_posts + @user_reposts
    @profile_posts = @profile_posts.sort_by{ |posts| posts.created_at }.reverse

    @post_time = []
    time_now = Time.now
    @profile_posts.each do |post|
      time_diff = time_now - post.created_at
      puts time_diff
      if time_diff < 3600.0
        puts "less than 3600.0"
        x = (time_diff/1.minute).to_i.round
        if x >= 1.5
          @post_time << "#{(time_diff/1.minute).to_i.round} minutes"
          puts "pushed to post time"
        else
          @post_time << "#{(time_diff/1.minute).to_i.round} minute"
        end
      elsif time_diff > 3600.0 && time_diff < 86400.0
        x = (time_diff/1.hour).to_i.round
        if x >= 1.5
          @post_time << "#{(time_diff/1.hour).to_i.round} hours"
        else
          @post_time << "#{(time_diff/1.hour).to_i.round} hour"
        end
      else
        x = (time_diff/1.day).to_i.round
        if x >= 1.5
          @post_time << "#{(time_diff/1.day).to_i.round} days"
        else
          @post_time << "#{(time_diff/1.day).to_i.round} day"
        end
      end
    end
  end

  def destroy_sesh
    sign_out_and_redirect(current_user)
  end

  def landing_page
  end

  def get_user
    if user_signed_in?
    @user_now = RSpotify::User.find(current_user.uid)
      @username = current_user.username
      if @user_now != nil
        @full_name = @user_now.display_name
        @all_playlists = @user_now.playlists
        @prof_pic_url = @user_now.images[0]["url"]
      end
    end
  end
end

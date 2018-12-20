class TweetsController < ApplicationController
  before_action :set_twitter_client, only: [:create]
  before_action :correct_user, only: [:destroy]
  before_action :search_tweet


  def index
    if user_signed_in?
      @tweet = current_user.tweets.build
    end
  end

  def create
    @diary = current_user.tweets.build(params_tweet)
    image = open("public#{@diary.image.url}")
    unless @diary.save && @twitter.update_with_media(@diary.content, image)
      redirect_to tweets_path
    end
  end

  def destroy
    @tweet.destroy
  end

  private

  def set_twitter_client
    @twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_API_SECRET']
      config.access_token= ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def params_tweet
    params.require(:tweet).permit(:content, :image)
  end

  def correct_user
    @tweet = current_user.tweets.find_by(id: params[:id])
    unless @tweet
      redirect_to root_path
    end
  end

  def search_tweet
    search_options = {
      created_after: params[:created_after],
      created_before: params[:created_before]
    }
    @q = Tweet.ransack(params[:q], search_options)
    @tweets = @q.result.page(params[:page]).per(50).order('created_at DESC')
  end
end

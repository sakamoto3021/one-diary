class TweetsController < ApplicationController
  before_action :set_twitter_client, only: [:create]

  def index
    if user_signed_in?
      @tweet = current_user.tweets.build
      @tweets = current_user.tweets.order('created_at DESC').page(params[:page])
    end
  end

  def create
    @tweets = current_user.tweets.order('created_at DESC').page(params[:page])
    @diary = current_user.tweets.build(params_tweet)
    if @diary.save && @twitter.update(params[:tweet][:content])
      flash[:success] = 'Tweetを保存しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      redirect_to tweets_path
    end
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
    params.require(:tweet).permit(:content)
  end
end

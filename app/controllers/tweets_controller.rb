class TweetsController < ApplicationController
  before_action :sign_in_required
  before_action :set_twitter_client, only: [:create]

  def index
    @tweet = current_user.tweets.build
  end

  def create
    @diary = current_user.tweets.build(params_tweet)
    if @diary.save
      @twitter.update(params_tweet)
      flash[:success] = 'ツイートを保存しました'
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
class StudyRecordCreationJob < ApplicationJob
  queue_as :default

  def perform(slack_user_id, user_name)
    user = User.find_or_create_by(slack_id: slack_user_id) do |u|
      u.name = user_name
    end

    StudyRecord.create!(user_id: user.id, start_time: Time.current)

    notify_slack("<@#{slack_user_id}>さんが勉強を開始しました！")
  rescue => e
    notify_slack("エラーが発生しました: #{e.message}")
  end

  private

  def notify_slack(message)
    Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"]).ping(message)
  end
end

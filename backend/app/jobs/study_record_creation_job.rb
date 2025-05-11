class StudyRecordCreationJob < ApplicationJob
  queue_as :default

  def perform(slack_user_id, user_name, response_url)
    user = User.find_or_create_by(slack_id: slack_user_id) do |u|
      u.name = user_name
    end

    StudyRecord.create!(user_id: user.id, start_time: Time.current)

  rescue => e
    post_to_slack(response_url, "エラーが発生しました: #{e.message}")
  end

  private

  def post_to_slack(response_url, message)
    notifier = Slack::Notifier.new(response_url)
    notifier.ping(message)
  end
end

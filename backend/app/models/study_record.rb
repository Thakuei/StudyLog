class StudyRecord < ApplicationRecord
  belongs_to :user

  def self.force_finish_all
    where(end_time: nil).find_each do |record|
      record.update(end_time: Time.current)

      Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"]).ping(
        "<@#{record.user.slack_id}>さんの勉強を21時になったので強制終了しました！"
      )
    end
  end
end

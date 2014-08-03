class User < ActiveRecord::Base
  has_secure_password
  validates :password, presence: true, on: :create

  delegate :recent_articles, :recent_tech_articles, :recent_diaries, :popular_articles, :period_articles, to: :articles

  class << self
    #
    # To use to create master user
    #
    def build_master(name, password)
      raise ArgumentError if name.blank? || password.blank?
      user = nil
      old_users = self.all.to_a
      transaction do
        user = self.create!(name: name, password: password, password_confirmation: password)
        old_users.each{|u| u.destroy}
      end
      user
    end

    def guest
      inst = self.new
      inst.guest!
      inst
    end
  end

  def articles
    @guest ? Article.published : Article.default_scoped
  end

  def guest!
    @guest = true
  end

  def guest?
    @guest
  end
end

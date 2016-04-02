class User < ActiveRecord::Base
  has_secure_password
  validates :password, presence: true, on: :create

  class << self
    #
    # To use to create master user
    #
    def build_master(name, password)
      raise ArgumentError if name.blank? || password.blank?
      user = nil
      old_users = all.to_a
      transaction do
        user = create!(name: name, password: password, password_confirmation: password)
        old_users.each(&:destroy)
      end
      user
    end

    def authenticate(name, password)
      return false unless user = find_by(name: name)
      user.authenticate(password) && user
    end
  end
end

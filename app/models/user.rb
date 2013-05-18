class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create

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
  end
end

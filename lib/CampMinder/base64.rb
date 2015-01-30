require "base64"

class CampMinder::Base64
  PAD_LENGTH = 4

  def self.urlsafe_encode64(bin)
    Base64.urlsafe_encode64(bin).gsub("=", "")
  end

  def self.urlsafe_decode64(str)
    mod = str.length % PAD_LENGTH
    str += "=" * (PAD_LENGTH - mod) unless mod == 0
    Base64.urlsafe_decode64(str)
  end
end

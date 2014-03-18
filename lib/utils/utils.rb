# Utility functions used inside app
#
# @author Ondrej Janata
module Utils

  # Generate random password of given length
  #
  # @param [Integer] length length of generated password
  # @return [String] Random password of given length
  def self.generate_random_password(length=10)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
    password = ''
    length.times { password << chars[rand(chars.size)] }
    password
  end

end
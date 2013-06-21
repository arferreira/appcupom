module EncryptionHelper

  def encrypt_password
    self.salt = make_salt unless password.blank?
    self.encrypted_password = encrypt(password) unless password.blank?
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
end

module Pass
  module Secure
    extend self

    def encrypt(data,key,iv)
      cipher = OpenSSL::Cipher.new("aes-256-cbc")
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv

      io = IO::Memory.new
      io.write(cipher.update(data))
      io.write(cipher.final)
      io.rewind

      io.to_slice
    end

    def decrypt(data,key,iv)
      cipher = OpenSSL::Cipher.new("aes-256-cbc")
      cipher.decrypt
      cipher.key = key
      cipher.iv = iv

      io = IO::Memory.new
      io.write(cipher.update(data))
      io.write(cipher.final)
      io.rewind

      io.gets_to_end
    end

  end
end
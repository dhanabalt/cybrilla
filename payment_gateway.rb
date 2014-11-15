require "base64"
require 'net/http'
class PaymentGateway
	def payment_request(payment_details)
		payload = "bank_ifsc_code=#{payment_details[:bank_ifsc_code]}|bank_account_number=#{payment_details[:bank_account_number]}|amount=#{payment_details[:amount]}|merchant_transaction_ref=#{payment_details[:merchant_transaction_ref]}|merchant_transaction_date=#{payment_details[:merchant_transaction_date]}|payment_gateway_merchant_reference=#{payment_details[:payment_gateway_merchant_reference]}"
		payload_with_sha = Digest::SHA1.hexdigest(payload)
		cipher = OpenSSL::Cipher::AES.new(128, :CBC)
		cipher.encrypt
		key = cipher.random_key
		iv = cipher.random_iv
		encrypted = cipher.update(payload_with_sha) + cipher.final
		msg = Base64.encode64(encrypted)
		url = "http://examplepg.com/transaction"
		response = Net::HTTP.post(URI.parse(url),msg)
		msg = Base64.decode64(response)
		decipher = OpenSSL::Cipher::AES.new(128, :CBC)
		decipher.decrypt
		decipher.key = key
		decipher.iv = iv
		txn_status = decipher.update(msg) + decipher.final
		split_msg = txn_status.split('|')
		puts "Transaction Status"
		split_msg.each do |params|
			puts params
		end
		return txn_statu
	end
end

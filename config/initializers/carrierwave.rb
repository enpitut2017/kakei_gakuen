CarrierWave.configure do |config|
    config.remove_previously_stored_files_after_update = true
    if Rails.env == 'production'
		config.fog_credentials = {
			
				:provider                         => 'Google',
				:google_storage_access_key_id     => ENV["GOOGLE_ACCESS_KEY"],
				:google_storage_secret_access_key => ENV["GOOGLE_SECRET_KEY"],
			
				}
        #config.cache_storage = :fog # 一時ファイルもオブジェクトストレージに保存する場合(LB使用時は必須)
        config.fog_directory = 'kakeigakuen' # バケット名を記述
    end    
end
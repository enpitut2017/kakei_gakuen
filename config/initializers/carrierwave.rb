CarrierWave.configure do |config|
    config.remove_previously_stored_files_after_update = true
    if Rails.env == 'production'
        config.fog_credentials = {
            provider:              'AWS', # IDCFでもAWSと記述
            path_style:            true,
            host:                  'ds.jp-east.idcfcloud.com',
            port:                  443,
            scheme:                'https',
            aws_access_key_id:     ENV['IDCF_ACCESS_KEY'], # アクセスキーを記述
            aws_secret_access_key: ENV['IDCF_SECRET_KEY'], # シークレットキー
            region:                'ap-northeast-1', # 東京
            aws_signature_version: 2
        }
        #config.cache_storage = :fog # 一時ファイルもオブジェクトストレージに保存する場合(LB使用時は必須)
        config.fog_directory = 'kakeigakuenimages' # バケット名を記述

        config.asset_host = 'kakeigakuenimages.ds.jp-east.idcfcloud.com' # CDNを使用しない場合
    end    
end
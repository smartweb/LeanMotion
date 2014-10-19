module LeanMotion
  class Config

    def self.init(app_id, app_key)
      if app_id == "your_app_id" || app_key == "your_app_key"
        NSLog("=========== LeanMotion Error ==========")
        NSLog("LeanCloud App ID and App Key require")
        NSLog("=======================================")
        return
      end

      AVOSCloud.setApplicationId(app_id, clientKey:app_key)
      AVOSCloud.useAVCloudCN
    end
       
    def self.channel(name)
      AVAnalytics.setChannel name
    end

  end
end

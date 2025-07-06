# app/controllers/proxy_controller.rb
require "open-uri"

class ProxyController < ApplicationController
  def image
    url = params[:url]

    # 校验 URL 白名单（简单处理）
    unless url&.start_with?("https://scontent")
      render plain: "Invalid URL", status: :bad_request and return
    end

    # 设置缓存头
    expires_in 6.hours, public: true

    # 转发图片数据
    image_data = URI.open(url).read
    send_data image_data, type: "image/jpeg", disposition: "inline"
  rescue => e
    Rails.logger.error "❌ Proxy image error: #{e.message}"
    head :not_found
  end
end

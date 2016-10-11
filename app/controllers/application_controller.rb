class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def go
    url = "http://www.baidu.com"
    url_parsed = URI.parse(url)
    method = request.request_method
    path = request.fullpath
    conn = Faraday.new(:url => url) do |f|
        f.use :cookie_jar
        f.request  :url_encoded             # form-encode POST params
        f.response :logger                  # log requests to STDOUT
        f.adapter :net_http_persistent
    end
    # 发送请求
    result = conn.send(method.downcase,path)
    if result.status.to_s[0]=='3' # 重定向
      new_url = URI.parse result.headers['location']
      new_url = request.host if new_url.host == url_parsed.host
      render nothing:true,status:result.status,location: new_url
      return
    end
    render text:result.body
  end

end

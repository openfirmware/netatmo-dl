module NetAtmoDL
  class Simple
    def login(user:, password:)
      conn = Faraday.new(url: "https://auth.netatmo.com") do |faraday|
        faraday.request :url_encoded
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end

      csrf_token = get_csrf_token(connection: conn, user: user, password: password)
      @access_token = get_access_token(connection: conn, csrf_token: csrf_token, user: user, password: password)
    end

    def getmeasurecsv(device_id:, module_id:, type:, startdate:, enddate:, format:)
      raise "No access token available - login first" unless @access_token

      conn = Faraday.new(url: "https://my.netatmo.com") do |faraday|
        faraday.request :url_encoded
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end

      response = conn.post do |req|
        req.url "/api/getmeasurecsv"
        req.body = build_params({
          access_token: @access_token,
          device_id:    CGI::escape(device_id),
          type:         type,
          module_id:    CGI::escape(module_id),
          scale:        "max",
          format:       format,
          datebegin:    startdate.strftime("%-m/%-d/%Y"), # m/d/Y
          timebegin:    startdate.strftime("%I:%M %P"), # h:M AM
          dateend:      enddate.strftime("%-m/%-d/%Y"), # m/d/Y
          timeend:      enddate.strftime("%I:%M %P"), # h:M AM
          date_begin:   startdate.strftime("%s"), # s
          date_end:     enddate.strftime("%s")  # s
        })
      end

      response.body
    end

    private

    def build_params(params_hash)
      params_hash.collect { |k,v|
        "#{k}=#{v}"
      }.join("&")
    end

    def get_access_token(connection:, csrf_token:, user:, password:)
      response = connection.post("/en-US/access/login", {
        ci_csrf_netatmo: CGI::escape(csrf_token),
        mail:            CGI::escape(user),
        pass:            CGI::escape(password),
        log_submit:      "LOGIN"
      })
      raise "Failed to get access token" if response.status != 302

      cookies = response.headers["set-cookie"].split(", ")
      token_cookie = cookies.find do |cookie|
        cookie.include?("netatmocomaccess_token") && !cookie.include?("deleted")
      end

      token_cookie.split("; ").at(0).split("=").at(1)
    end

    def get_csrf_token(connection:, user:, password:)
      response = connection.get("/en-US/access/login")
      raise "Failed to login" if response.status != 200

      cookies = response.headers["set-cookie"].split(", ")
      csrf_cookie = cookies.find do |cookie|
        cookie.include?("netatmocomci_csrf_cookie_na")
      end

      csrf_cookie.split("; ").at(0).split("=").at(1)
    end
  end
end

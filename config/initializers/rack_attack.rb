class Rack::Attack
    safelist('allow from localhost') do |req|
        # Requests are allowed if the return value is truthy
        '127.0.0.1' == req.ip || '::1' == req.ip
    end

    throttle("requests by ip", limit: 5, period: 2) do |request|
        request.ip
    end

    throttled_response = lambda do |env|
        match_data = env['rack.attack.match_data']
        now = match_data[:epoch_time]
      
        headers = {
          'RateLimit-Limit' => match_data[:limit].to_s,
          'RateLimit-Remaining' => '0',
          'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s
        }
      
        [ 429, headers, ["Throttled\n"]]
      end

end
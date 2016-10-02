require 'open-uri'
require 'logger'

class Fetcher
  @@config = nil
  def getUrl (url_str, cookie = nil)
    url = URI::encode(url_str)
    file_save = false
    filename = "tmp/http/" + self.sanitize_name(url)
    if file_save && File.exists?(filename) && (File.mtime(filename).to_i - Time.now.to_i) > 3600
      o = File.read(filename)
    else
      o = self.get_url_content(url, cookie)
      if file_save
        File.open(filename, 'w') {|f| f.write(o.force_encoding('UTF-8')) }
      end
    end
    o
  end

  def get_url_content (url, cookie = nil)
    t1 = (Time.now.to_f * 1000).to_i

    agent = get_user_agent
    t0 = (Time.now.to_f * 1000).to_i
    session = nil
    begin
      if url.include? 'http'
        if cookie == nil
          session = open(url, "User-Agent" => agent, "Accept-Encoding" => "gzip")
        else
          session = open(url, "User-Agent" => agent, "Cookie" => cookie, "Accept-Encoding" => "gzip")
        end
        if session.meta['content-encoding'] && session.meta['content-encoding'].include?('gzip')
          o = Zlib::GzipReader.new(session).read
        else
          o = session.read
        end
      else
        session = open(url)
        o = session.read
      end

    rescue Exception => e
      Rails.logger.info "Fetcher: #{url}. Error #{e}"
      throw e
    ensure
      if session != nil
        session.close
      end
    end

    t2 = (Time.now.to_f * 1000).to_i

    Rails.logger.info "Fetcher: #{url} #{(t2 - t1).to_i.round} ms"

    o
  end

  def sanitize_name(name)
    name.gsub(/[^0-9A-Za-z.\-]/, '-')
  end

  def get_user_agent
    if @@config == nil
      @@config = Array.new
      File.open('./config/user-agents.txt', 'r').each_line do |line|
        if line != nil
          @@config.push(line.strip)
        end
      end
      Rails.logger.info "Agents: #{@@config.to_json}"
    end
    @@config[rand(@@config.count)]
  end
end


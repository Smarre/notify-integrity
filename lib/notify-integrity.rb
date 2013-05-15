
require "net/http"
require "uri/http"
require "mechanize"

class NotifyIntegrity

    # #
    # Adds authentication information of Integrity instance.
    #
    def auth user, pass
        @integrity_user = user
        @integrity_pass = pass
    end

    # uses Net::HTTP
    def post_request host, path, payload = {}
        uri = URI("#{host}#{path}")
        req = Net::HTTP::Post.new uri.path
        req.basic_auth @integrity_user, @integrity_pass unless @integrity_user.nil?
        req.set_form_data payload

        result = nil
        Net::HTTP.start(uri.hostname, uri.port) do |http|
            result = http.request(req)
        end

        if result.instance_of? Net::HTTPNotFound
            raise Net::HTTPNotFound, "Requested page does not exist (404). host: #{host}, path: #{path}"
            result = nil
        end

        result
    end

    # uses Mechanize
    def request_page uri
        raise "invalid uri" if uri.nil?
        raise "integrity user or pass missing" if @integrity_user.nil? or @integrity_pass.nil?

        agent = Mechanize.new
        agent.add_auth uri, @integrity_user, @integrity_pass
        agent.get uri
    end
end
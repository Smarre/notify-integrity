
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

    # #
    # Do a POST request to integrity.
    #
    # TODO: this should use Mechanize too.
    # uses Net::HTTP
    #
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

    # #
    # Requests a page from integrity.
    #
    # uses Mechanize
    #
    def request_page uri
        raise "invalid uri" if uri.nil?
        raise "integrity user or pass missing" if @integrity_user.nil? or @integrity_pass.nil?

        agent = Mechanize.new
        agent.add_auth uri, @integrity_user, @integrity_pass
        agent.get uri
    end

    # #
    # Queries integrity until the build has succeeded.
    #
    # WARNING: in current form, this continues looping until the integrity
    # responds success or goes down by some server failure. I’ve had some
    # situations where Integrity has created infinite build loop,
    # which would cause this to loop infinitely too. Patches welcome.
    #
    # Returns true is success, false if not
    #
    def check_for_success uri
        element = nil

        while true

            base = GerritHooks::Base.new
            page = base.request_page uri

            element = page.parser.at_xpath "//div[@class='building']"
            break if element.to_s == ""
            sleep 1
        end

        element = page.parser.at_xpath "//div[@class='success']"

        # failure
        if element.to_s == ""
            success = false
        else
            success = true
        end

        success
    end
end
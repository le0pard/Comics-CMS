%w(rubygems sinatra ftools haml controllers models).each  { |lib| require lib}

#options
set :root, File.dirname(__FILE__)
set :public, File.dirname(__FILE__) + "/public"
set :views, File.dirname(__FILE__) + "/views"
set :environment, :production
set :sessions, true

helpers do
  
  include Rack::Utils
  
  alias_method :h, :escape_html

  def protected!
    response['WWW-Authenticate'] = %(Basic) and \
    throw(:halt, [401, "Not authorized\n"]) and \
    return unless authorized?
  end

  def authorized?
    admin = {:login => 'leo', :password => 'fluidogen210'}
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [admin[:login], admin[:password]]
  end
  
  def url_for url_fragment, mode=:full
    case mode
    when :path_only
      base = request.script_name
    when :full
      scheme = request.scheme
      if (scheme == 'http' && request.port == 80 || scheme == 'https' && request.port == 443)
        port = ""
      else
        port = ":#{request.port}"
      end
      base = "#{scheme}://#{request.host}#{port}#{request.script_name}"
    else
      raise TypeError, "Unknown url_for mode #{mode}"
    end
    "#{base}#{url_fragment}"
  end
  
  def url_for_rss url_fragment
    scheme = request.scheme
    if (scheme == 'http' && request.port == 80 || scheme == 'https' && request.port == 443)
      port = ""
    else
      port = ":#{request.port}"
    end
    base = "#{scheme}://#{request.host}#{port}"
    "#{base}#{url_fragment}"
  end

end
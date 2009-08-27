### CONTROLLER ACTIONS
layout 'layout.haml'
#uploads only images
FILE_TYPES = ["image/jpeg", "image/pjpeg", "image/gif", "image/png", "image/x-png"]

['/admin/?', '/admin/dashboard'].each do |path|
  get path do
    protected!
    haml(:admin_index)
  end
end

get '/admin/add' do
  protected!
  haml(:admin_add)
end

post '/admin/add' do
  protected!
  if params[:comics]
    if params[:comics][:image]
      tempfile = params[:comics][:image][:tempfile]
      if FILE_TYPES.include?(params[:comics][:image][:type].chomp)
        s = ""
        10.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
        s += "." + params[:comics][:image][:filename].gsub(/.*\./, '')
        @comics = Comics.new(
                        :title => params[:comics][:title],
                        :description => params[:comics][:description],
                        :image => "/files/" + s)
        File.copy(tempfile.path, File.expand_path("public/files/#{s}", File.dirname(__FILE__)))
        File.chmod(0755, File.expand_path("public/files/#{s}", File.dirname(__FILE__)))
        @comics.save!
      end
    end
  end
  if @comics
    redirect "/admin/edit/#{@comics.id}"
  else
    redirect "/admin/list"
  end
  
end

get '/admin/edit/:id' do
  protected!
  @comics = Comics.get(params[:id])
  haml(:admin_edit)
end

post '/admin/edit/:id' do
  protected!
  @comics = Comics.get(params[:id])
  @comics.attributes = params[:comics].except(:id, :image)
  if params[:comics][:image]
    tempfile = params[:comics][:image][:tempfile]
    if FILE_TYPES.include?(params[:comics][:image][:type].chomp)
      s = ""
      10.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
      s += "." + params[:comics][:image][:filename].gsub(/.*\./, '')
      @comics.image = "/files/" + s
      File.copy(tempfile.path, File.expand_path("public/files/#{s}", File.dirname(__FILE__)))
    end
  end
  @comics.save!
  redirect "/admin/edit/#{@comics.id}"
end

get '/admin/delete/:id' do
  protected!
  @comics = Comics.get(params[:id])
  File.delete(File.expand_path("public#{@comics.image}", File.dirname(__FILE__)))
  @comics.destroy
  redirect '/admin/list'
end

get '/admin/list' do
  protected!
  limit = 500
  @comics_list = Comics.all :limit => limit
  haml(:admin_list)
end



['/list/?', '/list/:page'].each do |path|
  get path do
    limit = 500
    if params[:page].blank?
      params[:page] = 1
    else
      params[:page] = params[:page].to_i
      if !(params[:page].is_a?(Integer))
        params[:page] = 1
      end
    end
    
    count = Comics.count
    @count = (count / limit.to_f).ceil
    
    page = params[:page] - 1
    if page < 0 || page >= @count
      redirect '/list'
    end
    @comics_list = Comics.all :limit => limit, :offset => (page*limit).to_i
    @page = params[:page]
    haml(:list)
  end
end

get '/about' do
  haml(:about)
end

get '/rss.xml' do
  content_type 'application/rss+xml', :charset => 'utf-8'
  @comics = Comics.all :limit => 10
  haml(:rss, :layout => false)
end

get '/sass_style.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :style, :layout => false
end

['/', '/index', '/:id'].each do |path|
  get path do
    if params[:id].blank?
      @comics = Comics.first
    else
      params[:id] = params[:id].to_i
      if !(params[:id].is_a?(Integer))
        redirect '/'
      end
      @comics = Comics.get(params[:id])
    end
    haml :index
    #erb :index
  end
end


error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].name
end


not_found do
  haml :l_404, :layout => false
end


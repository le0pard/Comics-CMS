%w(rubygems datamapper).each { |lib| require lib }
#database
configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/database.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/database.db")
end

class DateTime
  def rfc822
    self.strftime "%a, %d %b %Y %H:%M:%S %z"
  end
end

#commics
class Comics
  include DataMapper::Resource
 
  # The Serial type provides auto-incrementing primary keys
  property :id,           Serial
  property :title,        String, :length => 0..255
  property :description,  Text
  property :image,        String, :length => 0..255
  property :created_at,   DateTime
  
  def get_next
    Comics.first(:created_at.gt => self.created_at, :order => [:created_at.asc])
  end
  
  def get_previous
    Comics.first(:created_at.lt => self.created_at)
  end
  
  def get_id
    self.id
  end
  
  default_scope(:default).update(:order => [:created_at.desc])
end

def install
  DataMapper.auto_migrate!
  sleep 1
  Comics.new(:title => 'Дятел', :description => 'Если у тебя не будет удлинителя, я его тоже смогу принести. Ведь мы же друзья! Правда?',
              :image => 'http://www.xkcd.ru/xkcd_img/xkcd614___.png', :created_at => Time.now).save!
end

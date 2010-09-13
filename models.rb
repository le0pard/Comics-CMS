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

  storage_names[:default] = "comicses"
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
  Comics.new(:title => 'Экстраполяция', :description => 'К седьмому месяцу в тебе будут сотни детей.',
              :image => 'http://www.xkcd.ru/xkcd_img/xkcd605_.png', :created_at => Time.now).save!
  sleep 1
  Comics.new(:title => 'Дятел', :description => 'Если у тебя не будет удлинителя, я его тоже смогу принести. Ведь мы же друзья! Правда?',
              :image => 'http://www.xkcd.ru/xkcd_img/xkcd614___.png', :created_at => Time.now).save!
  sleep 1
  Comics.new(:title => 'Идиократия', :description => 'Люди не изменятся, хорошо это или плохо. Технология станет круче. В общем, будущее в порядке! За исключением климата; его мы всё-таки просрали.',
              :image => 'http://www.xkcd.ru/xkcd_img/xkcd_603_idiocracy_ru-4.png', :created_at => Time.now).save!
end

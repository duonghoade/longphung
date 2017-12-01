class Article < ApplicationRecord
  has_many :games
  has_many :matches, as: :matchable

  def self.slug(string)
    string = string.strip
    return false if !string
    unicodes = {
        'a' => ['á','à','ả','ã','ạ','ă','ắ','ặ','ằ','ẳ','ẵ','â','ấ','ầ','ẩ','ẫ','ậ'],
        'A' => ['Á','À','Ả','Ã','Ạ','Ă','Ắ','Ặ','Ằ','Ẳ','Ẵ','Â','Ấ','Ầ','Ẩ','Ẫ','Ậ'],
        'd' => ['đ'],
        'D' => ['Đ'],
        'e' => ['é','è','ẻ','ẽ','ẹ','ê','ế','ề','ể','ễ','ệ', 'ệ', 'ẹ'],
        'E' => ['É','È','Ẻ','Ẽ','Ẹ','Ê','Ế','Ề','Ể','Ễ','Ệ'],
        'i' => ['í','ì','ỉ','ĩ','ị', 'ì', 'ị'],
        'I' => ['Í','Ì','Ỉ','Ĩ','Ị'],
        'o' => ['ó','ò','ỏ','õ','ọ','ô','ố','ồ','ổ','ỗ','ộ','ơ','ớ','ờ','ở','ỡ','ợ', 'ó', 'ò'],
        'O' => ['Ó','Ò','Ỏ','Õ','Ọ','Ô','Ố','Ồ','Ổ','Ỗ','Ộ','Ơ','Ớ','Ờ','Ở','Ỡ','Ợ'],
        'u' => ['ú','ù','ủ','ũ','ụ','ư','ứ','ừ','ử','ữ','ự', 'ự', 'ự', 'ụ'],
        'U' => ['Ú','Ù','Ủ','Ũ','Ụ','Ư','Ứ','Ừ','Ử','Ữ','Ự'],
        'y' => ['ý','ỳ','ỷ','ỹ','ỵ'],
        'Y' => ['Ý','Ỳ','Ỷ','Ỹ','Ỵ'],
        '-' => [' - ', '---', '-–-', ' – ', ' ', '_', '--'],
        '' => [',', '[', ']', "'",'"', '?', '/', '|', '>', '<', "”", ":",'&quot;','.', ")", "(", "!", '+'],
      }
    unicodes.each do |non_unicode, unicode|
      unicode.each do |value|
        string.gsub!(value, non_unicode)
      end
    end
   string.strip.downcase.chomp("-")
  end

  def self.crawl
    require 'open-uri'
    url = "http://cohet.org/clip/all"
    doc = Nokogiri::HTML open(url, proxy: "http://42.116.18.180:53281")
    articles = doc.css('table.tablecat').css('tr')
    articles.reverse.each do |article|
      Article.transaction do
        full_url = article.css('a').first[:href]
        if Article.find_by(source: full_url).blank?
          detail_doc = Nokogiri::HTML open(full_url, proxy: "http://42.116.18.180:53281")
          title = detail_doc.css('.hotvideos').css('h1').text
          new_article = Article.create(
            title: title,
            url_slug: slug(slug(title)),
            source: full_url,
            thumbnail: detail_doc.css('.clip-same-item-img').first[:src]
          )
          matches = detail_doc.css('table.tablecat').css('tr').reverse
          matches.each_with_index do |match, i|
            match_url = match.css('a').first[:href]
            match_title = match.css('a').text.strip
            begin
              game_id = match_title[(match_title.length - 4)..-1].split(".").first.gsub("C", "")
              match_doc = Nokogiri::HTML open(match_url, proxy: "http://42.116.18.180:53281")
              youtube_url = match_doc.css('.hotvideos').css('iframe').first[:src]
              if game_id.to_i == 0
                if match_title[match_title.length-2..-1].first.upcase == "T" && match_title[match_title.length-2..-1].last.to_i != 0
                  new_match = new_article.matches.create!(youtube_url: youtube_url, title: match_title, sort_no: match_title[match_title.length-2..-1].last.to_i)
                else
                  new_match = new_article.matches.create!(youtube_url: youtube_url, title: match_title)
                end
              else
                sort_no = match_title.last.to_i
                game = new_article.games.where(c_num: game_id.to_i).first_or_create
                new_match = game.matches.create!(title: match_title, youtube_url: youtube_url, sort_no: sort_no)
                if game_id.to_i == 1 && sort_no == 1
                  new_article.update(first_match_id: new_match.id)
                end
              end
              if i == matches.length - 1 && new_article.first_match_id.nil?
                new_article.update(first_match_id: new_match.id)
              end
            rescue => e
              binding.pry
            end
          end
          
        end
      end
    end
  end

end

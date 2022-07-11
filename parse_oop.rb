

class Parser

   def initialize()
      require 'open-uri'
      require 'nokogiri'
      require 'json'
   end
   def parse(url)

      clean_url = url
      id = url.split('/').last
      main_url = url.split('com')[0] + 'com' 
      # That looks shitty, by just have not time to find better solution
      url  = main_url + '/?sp=profile&sp_mode=contact&eid_s=' + id
      
      
      contact_url = url.split('/')
      
      
      html = URI.open(url)
      
      doc = Nokogiri::HTML(html)
    
    
      # find lang data 
      target_lang = doc.css('#lang_full > span').map { |lang| lang.text.strip }
    
      # Makes a good format with uniq text
      target_lang = target_lang.map { |p| p.split('to')}.join(",").split(',')
      target_lang = target_lang.uniq
      target_lang = target_lang.map { |p| p.gsub(/[[:space:]]/, '') }.join(", ")
    
      # finds Full Name 
      name = doc.css('#fullNameView').text.strip
      first_name = name.split(' ')[0]
      last_name = name.split(' ')[1]
    
      country = doc.css('#countryView').text.strip
      native_lang = doc.css('#tagline ~ .pd_bot').text.split(':').last.gsub(/[[:space:]]/, '')
    
    
     
    
      res = {
        url: clean_url,
        first_name: first_name,
        last_name: last_name,
        target_lang: target_lang,
        native_lang: native_lang,
        country: country,
      }
    
    
    return JSON.pretty_generate(res)
    end
end


# init the process

url = 'https://www.proz.com/profile/52171'
p = Parser.new()
puts p.parse(url)



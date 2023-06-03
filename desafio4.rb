require 'uri'
require 'net/http'
require 'json'

def request(url_requested)
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(url)
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'
    response = http.request(request)
    return JSON.parse(response.body)
end

data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=DEMO_KEY')
photos = data['photos'].map{|photo| photo['img_src']}

def build_web_page(fotos)
    li = ""
    fotos.each do |foto|
        li += "<li><img src=\"#{foto}\"></li>\n"
    end

    html = "<html><head></head><body><ul>#{li}</ul></body></html>"
    return html
end

html = build_web_page(photos)

File.write('desafio4.html', html)
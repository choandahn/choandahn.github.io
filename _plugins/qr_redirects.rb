# 명함 QR 리다이렉트: _data/qr.yml의 id마다 /qr/<id>/ 페이지를 만든다(레이아웃 _layouts/qr.html).
# 목록에 없는 /qr/ 주소는 404.html이 unknown 목적지로 보낸다. 운영 방법은 README.md.
# 인쇄된 QR이 잘못된 곳으로 가지 않도록, id나 주소가 이상하면 빌드를 멈춘다(배포된 이전 버전이 그대로 남음).
require "uri"

module QrRedirects
  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      targets = site.data["qr"] || {}
      fail!("unknown 목적지가 없습니다") unless targets.key?("unknown")

      targets.each do |id, url|
        id = id.to_s
        url = url.to_s
        fail!("id는 영문 소문자, 숫자, -, _만 씁니다: #{id}") unless id.match?(/\A[a-z0-9_-]+\z/)
        uri = URI.parse(url) rescue nil
        fail!("#{id}의 목적지가 http(s) 주소가 아닙니다: #{url}") unless uri.is_a?(URI::HTTP) && uri.host

        page = Jekyll::PageWithoutAFile.new(site, site.source, "qr/#{id}", "index.html")
        page.content = ""
        page.data.merge!("layout" => "qr", "destination" => url, "sitemap" => false)
        site.pages << page
      end
    end

    private

    def fail!(message)
      raise Jekyll::Errors::FatalException, "_data/qr.yml: #{message}"
    end
  end
end

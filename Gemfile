source "https://rubygems.org"

# Modern Jekyll (로컬 빌드). GitHub Pages 배포는 .github/workflows/pages.yml에서.
gem "jekyll", "~> 4.3"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-sitemap"
end

# Ruby 3.4+는 아래 stdlib gem들이 기본 포함이 아니므로 명시
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"

# Windows/ARM 호환
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
gem "tzinfo-data", platforms: [:mingw, :x64_mingw, :mswin, :jruby]

json.array! @pages do |page|
  json.page do
    json.title page.title
    json.lead page.lead
    json.url page.url
  end
end

json.array! @pages do |page|
  json.page do
    json.title page.title
    json.body "body"
  end
end

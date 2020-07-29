json.extract! gif, :id, :gif_name, :gif_url, :gif_tags, :created_at, :updated_at
json.url gif_url(gif, format: :json)

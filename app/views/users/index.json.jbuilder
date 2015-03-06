json.array!(@users) do |user|
  json.extract! user, :id, :name, :mobile, :address, :city, :state, :country, :zip, :about, :profile_pic
  json.url user_url(user, format: :json)
end

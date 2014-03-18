json.array!(@roles) do |role|
  json.extract! role, :name, :protected, :superadmin, :administrator, :guess, :description
  json.url role_url(role, format: :json)
end

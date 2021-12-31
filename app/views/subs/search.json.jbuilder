json.array!(@subs) do |user|
    json.(sub, *Sub.column_names)
end
  
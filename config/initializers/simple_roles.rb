SimpleRoles.configure do
  valid_roles :user, :editor, :admin
  strategy :one # Other choice is :many
end

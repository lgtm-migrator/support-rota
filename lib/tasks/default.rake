task default: %i[standard spec cucumber] if Rails.env.test? || Rails.env.development?

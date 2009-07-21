# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ZhiWenKu_session',
  :secret      => '7f1945bd91934f0d68565589e18919c584ebce8c810d8954f0d33725c6e2e45670d331859fb36344cc9f36ed73d5f49be56ff27b617f4e74d8aec4bd2f8359b7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

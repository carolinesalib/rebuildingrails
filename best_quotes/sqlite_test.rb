# frozen_string_literal: true

require "sqlite3"
require "rulers/sqlite_model"

class MyTable < Rulers::Model::SQLite; end
warn MyTable.schema.inspect

# Create row
mt = MyTable.create(
  "title" => "It happened!",
  "posted" => 1,
  "body" => "It did!"
)

mt.title = "I really did!"
mt.save!

mt2 = MyTable.find(mt["id"])

puts "Title: #{mt2.title}"
# mt = MyTable.create "title" => "I saw it!"
#
# puts "Count: #{MyTable.count}"
#
# top_id = mt["id"].to_i
# (1..top_id).each do |id|
#   mt_id = MyTable.find(id)
#   puts "Found title #{mt_id["title"]}"
# end

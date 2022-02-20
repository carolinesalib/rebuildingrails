# frozen_string_literal: true

require "sqlite3"
require "rulers/util"

DB = SQLite3::Database.new("test.rb")

module Rulers
  module Model
    class SQLite
      def initialize(data = nil)
        @hash = data

        @hash.keys.each do |hash_key|
          define_singleton_method(hash_key) do
            @hash[hash_key]
          end

          define_singleton_method(hash_key + "=") do |value|
            @hash[hash_key] = value
          end
        end
      end

      def self.find(id)
        row = DB.execute <<~SQL
          select #{schema.keys.join(",")} from #{table}
          where id = #{id};
        SQL

        data = schema.keys.zip(row[0]).to_h
        new(data)
      end

      def self.to_sql(val)
        case val
        when NilClass
          "null"
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.create(values)
        values.delete("id")
        keys = schema.keys - ["id"]

        vals = keys.map do |key|
          values[key] ? to_sql(values[key]) :
            "null"
        end

        DB.execute <<~SQL
          INSERT INTO #{table} (#{keys.join ","})
            VALUES (#{vals.join ","});
        SQL

        raw_vals = keys.map { |k| values[k] }
        data = (keys.zip raw_vals).to_h
        sql = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        new data
      end

      def save!
        unless @hash["id"]
          self.class.create
          return true
        end

        fields = @hash.map do |k, v|
          "#{k}=#{self.class.to_sql(v)}"
        end.join(",")

        DB.execute <<~SQL
          UPDATE #{self.class.table}
          SET #{fields}
          WHERE id = #{@hash["id"]}
        SQL
        true
      end

      def save
        save!
      rescue
        false
      end

      def self.count
        DB.execute(<<~SQL)[0][0]
          SELECT COUNT(*) FROM #{table}
        SQL
      end

      def self.table
        Rulers.to_underscore(name)
      end

      def self.schema
        return @schema if @schema

        @schema = {}
        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end
        @schema
      end
    end
  end
end

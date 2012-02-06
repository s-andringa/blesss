require "redis"

class Person < Struct.new(:username, :cnt, :latest_at)

  class << self
    def connection
      @connection ||= Redis.new
    end

    def bless(username)
      connection.sadd "people", username
      connection.hincrby "person:#{username}", "cnt", 1
      connection.hset "person:#{username}", "latest_at", Time.now.to_i
      connection.publish(:blessings, Person.find(username).to_json)
      connection.publish(:top_5, top_blessed(5).to_json)
    end

    def last_blessed(limit)
      sort_and_limit("latest_at", :desc, limit)
    end

    def top_blessed(limit)
      sort_and_limit("cnt", :desc, limit)
    end
    
    def find(username)
      attrs = connection.hgetall("person:#{username}")
      if attrs.values.any?
        Person.new(username, attrs["cnt"], attrs["latest_at"])
      else
        raise "Person not found"
      end
    end

    private

    def sort_and_limit(order, direction, limit)
      results = self.connection.sort("people",
        by: "person:*->#{order}",
        order: direction.to_s,
        limit: [0, limit],
        get: members.map { |m| m == :username ? "#" : "person:*->#{m}" }
      )
      results.enum_for(:each_slice, members.size).map do |attrs|
        new(*attrs)
      end
    end
  end

  def latest_at
    self[:latest_at] ? Time.at(self[:latest_at].to_i).strftime("%d/%m, %H:%M") : nil
  end
  
  def to_json(options = {})
    to_hash.to_json options
  end
  
  def to_hash
    members.inject({}) do |hash, attr|
      hash[attr] = send(attr)
      hash
    end
  end
end
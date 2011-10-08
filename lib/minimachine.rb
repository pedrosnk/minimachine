require 'redis'
require 'yaml'

module MiniMachine
  VERSION = "0.0.1.a".freeze

  VALUES_ARRAY = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
                 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
                 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
                 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                 'Y', 'Z' ]

  def self.convert_id(id)
    value = id
    s_id = ''
    while value > 0
      s_id << VALUES_ARRAY[value % VALUES_ARRAY.size]
      value = value / VALUES_ARRAY.size
    end
    s_id.reverse
  end

  def self.convert_url_str(s_id = '')
    value = 0
    idx = 0
    s_id.reverse.each_char do |c|
      value += VALUES_ARRAY.index(c) * (VALUES_ARRAY.size ** idx)
      idx += 1
    end
    value
  end

  class MiniMe
    @@config_file = '../minimachine_config.yaml'

    def self.config_file_path=(path)
      @@config_file = path
    end

    def initialize(args = nil)
      connect(args)
    end

    def connect(args = nil)
      unless args
        begin 
          y = YAML.load_file(@@config_file)
          args = y['minime']
        rescue Errno::ENOENT => error
          puts "error reading config file!" + error.to_s
          raise error
        end
      end

      begin
        @redis = Redis.new(args)
        @redis.ping
      rescue Errno::ECONNREFUSED => error
        puts error.to_s
        raise error
      end
    end

    def connected?
      if @redis
        @redis.ping != nil
      else
        false
      end
    end

    def insert_url(url_s, s_label = nil)
      if s_label
        shorted_key = @redis.get('url:native:' + s_label)
        unless shorted_key
          @redis.set('url:key:' + s_label,url_s)
          @redis.set('url:native:' + url_s, s_label)
          shorted_key = s_label
        else
          puts 'name already taken'
        end
      else
        shorted_key = @redis.get('url:native:' + url_s)
        unless shorted_key 
          verify_new_shorted_key = nil
          begin
            key_id = last_id
            shorted_key = MiniMachine.convert_id(key_id)
            verify_new_shorted_key = @redis.get('url:key:' + shorted_key.to_s)
          end while verify_new_shorted_key != nil
          @redis.set('id:count',key_id)
          @redis.set('url:key:' + shorted_key.to_s,url_s)
          @redis.set('url:native:' + url_s, shorted_key.to_s)
        end
      end
      shorted_key
    end

    def recover_url(key_id)
      @redis.get('url:key:' + key_id.to_s)
    end

    def to_s
      "Am I connected and ready?: #{connected?}."
    end

    private

    def last_id
      id = @redis.get('id:count')
      unless id
        id = 1
      else
        begin
          id = 1 + id.to_i
          url_value = @redis.get('url:key:' + id.to_s)
        end while url_value != nil
      end
      id
    end

  end

end
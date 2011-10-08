require '../lib/minimachine'
require 'minitest/spec'
require 'minitest/autorun'

describe MiniMachine do

  it 'should convert id types in a way and another' do
    100000.times do |i|
      s_id = MiniMachine.convert_id(i)
      assert MiniMachine.convert_url_str(s_id) == i
    end
  end

  it 'should connect succefully with the server declared at the yaml file' do
    mini = MiniMachine::MiniMe.new
    mini.connect
    assert mini.connected?
  end

  it 'should connect succefully with ther server by passing server configs' do
    mini = MiniMachine::MiniMe.new
    mini.connect(:host => '127.0.0.1', :port => 6379)
    assert mini.connected?
  end

  describe 'connection tests' do

    before do
      @mini = MiniMachine::MiniMe.new
      @mini.connect
    end

    it 'should register a new sort url' do
      skip("couldn't connect") unless @mini.connected?
	    assert @mini.insert_url('http://google.com')
    end

    it 'should registar and recover the same url' do
      skip("couldn't connect") unless @mini.connected?
      url_s = 'http://www.gmail.com'
      assert( url_id = @mini.insert_url(url_s) )
      recover = @mini.recover_url(url_id)
      assert url_s == recover
    end

    it 'should registar a new url using a personalized name and recover it' do
      skip("couldn't connect") unless @mini.connected?
      key = 'personizeurlkey'
      url = 'http://personized_url_key.net'
      assert @mini.insert_url(url, key)
      recover_url = @mini.recover_url(key)
      assert recover_url == url
    end
    	
  end

end

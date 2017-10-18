require_relative './lib/gist'
require 'yaml'

config = YAML.load_file('./config/config.yml')

regex = config['console_regex']

puts 'Example => directory|file true|false description'

loop do
  input = gets.chomp
  if input =~ regex
    path, public, description = input.match(regex).captures
    begin
      gist = Gist.new(path, public, description)
      puts gist.upload()
    rescue Exception => error
      puts error
    end
  else
    puts 'Mismatch command'
  end
end

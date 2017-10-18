require 'yaml'
require_relative './progressBar'

module FileReader
  @config = YAML.load_file('config/config.yml')
  include ProgressBar

  def self.read(path)
    chunkSize = @config['chunk_size']
    readed = ''
    total = 0
    File.open(path) do |io|
      total = io.size
      io.each(nil,chunkSize) do |chunk|
        readed << chunk
        ProgressBar.progress(path, readed.size, io.size)
      end
    end
    ProgressBar.progress(path, total, total)
    readed
  end
end

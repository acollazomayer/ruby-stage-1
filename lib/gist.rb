require 'pathname'
require_relative './request'
require_relative './progressBar'
require_relative './fileReader'

class Gist
  include Request
  include ProgressBar
  include FileReader

  attr_reader :gist

  def initialize(path, public = true, description = '')
    @gist = {
      description: description,
      public: public,
      files: createDocuments(path)
    }
  end

  def upload
    response = Request.post(@gist)
    body = JSON.parse(response.body)
    response.code == '201' ? body["html_url"] : body
  end

end

def createDocuments(path)
  files = {}
  if pathExists?(path)
    if File.directory?(path)
      procdir(path).each do |filePath|
        pathName = Pathname(filePath)
        files[pathName.basename] = {content: FileReader.read(filePath)}
      end
    else
      files[Pathname(path).basename] = {content: FileReader.read(path)}
    end
    files
  else
    raise 'File or Directory not found'
  end
end

def pathExists?(path)
  pathName = Pathname(path)
  pathName.exist?
end

def procdir(path)
  Dir[File.join(path, '**', '*')].reject { |p| File.directory? p }
end

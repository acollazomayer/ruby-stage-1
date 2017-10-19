require 'pathname'
require_relative './request'
require_relative './file_reader'

class Gist
  include Request
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
    body = response[:body]
    response[:code] == '201' ? body["html_url"] : body
  end

end

def createDocuments(path)
  files = {}
  if pathExists?(path)
    if File.directory?(path)
      procdir(path).each do |file_path|
        path_name = Pathname(file_path)
        files[path_name.basename.to_s] = {content: FileReader.read(file_path)}
      end
    else
      files[Pathname(path).basename.to_s] = {content: FileReader.read(path)}
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

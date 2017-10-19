require 'fileutils'
require 'webmock/rspec'
require_relative '../lib/request'
require_relative '../lib/gist'

describe Gist do
  gist = nil
  gist_content = nil

  before do
    FileUtils.mkdir_p('dir_deep')
    File.write('dir_deep/file.rb', 'file content')
    FileUtils.mkdir_p('dir_deep/dir2')
    File.write('dir_deep/dir2/file1.rb', 'file content')
    FileUtils.mkdir_p('dir_shallow')
    FileUtils.mkdir_p('dir_empty')
    File.write('dir_shallow/file.rb', 'file content')
    File.write('file.rb', 'file content')
    File.write('empty.rb', '')

  end

  after do
    File.delete('file.rb')
    File.delete('empty.rb')
    FileUtils.rm_r ('dir_deep')
    FileUtils.rm_r ('dir_shallow')
    FileUtils.rm_r ('dir_empty')
  end

  describe '.new' do

    context 'when a file is given' do

      before do
        gist = Gist.new('file.rb', true, 'description')
        gist_content = {
          files: {
            'file.rb' => {
              content: 'file content'
              }
          },
          description: 'description',
          public: true
        }
      end

      subject { gist.gist }
      it { is_expected.to eql(gist_content) }
    end

    context 'when a shallow directory is given' do

      before do
        gist = Gist.new('dir_shallow', true, 'description')
        gist_content = {
          files: {
            'file.rb' => {
              content: 'file content'
              }
          },
          description: 'description',
          public: true
        }
      end

      subject { gist.gist }
      it { is_expected.to eql(gist_content) }
    end

    context 'when a deep directory is given' do

      before do
        gist = Gist.new('dir_deep', true, 'description')
        gist_content = {
          files: {
            'file.rb' => {
              content: 'file content'
            },
            'file1.rb' => {
              content: 'file content'
            }
          },
          description: 'description',
          public: true
        }
      end

      subject { gist.gist }
      it { is_expected.to eql(gist_content) }
    end

    context 'when a empty directory is given' do

      before do
        gist = Gist.new('dir_empty', true, 'description')
        gist_content = {
          files: {},
          description: 'description',
          public: true
        }
      end

      subject { gist.gist }
      it { is_expected.to eql(gist_content) }
    end

    context 'when a empty file is given' do

      before do
        gist = Gist.new('empty.rb', true, 'description')
        gist_content = {
          files: {
            'empty.rb' => {
              content: ''
            },
          },
          description: 'description',
          public: true
        }
      end

      subject { gist.gist }
      it { is_expected.to eql(gist_content) }
    end

  end

  describe '.upload' do

    context 'when a gist is uploaded' do
      response = {
        html_url: 'http://someurl.com'
      }

      before do
        gist = Gist.new('file.rb', true, 'description')
        stub_request(:post, /.*/).
        to_return(status: 201, body: response.to_json)
      end

      subject { gist.upload() }
      it { is_expected.to eql('http://someurl.com') }
    end

    context 'when an the request returns an error' do
      response = {
        'message' => 'someerror',
        'errors' => [
          {
            'resource' => 'someresource',
            'code' =>'somecode',
            'field' => 'somefiled'
          }
        ],
        'documentation_url' => 'someurl'
      }

      before do
        stub_request(:post, /.*/).
        to_return(status: 300, body: response.to_json)
        gist = Gist.new('file.rb', true, 'description')
      end

      subject { gist.upload() }
      it { is_expected.to eql(response) }
    end
  end
end

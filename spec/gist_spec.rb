require_relative "../lib/gist"

describe Gist do

  describe 'new' do
    context 'When a file is given' do
      it 'creates a new gist' do
        expect(FileReader.read('file.rb')).to eql('file content')
      end
    end

    context 'When an empty file is given' do
      it 'returns an empty string' do
        expect(FileReader.read('empty.rb')).to eql('')
      end
    end
  end
end

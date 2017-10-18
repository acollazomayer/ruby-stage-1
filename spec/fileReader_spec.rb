require_relative "../lib/fileReader"

describe FileReader do

  before do
    File.write('file.rb', 'file content')
    File.write('empty.rb', '')
  end

  after do
    File.delete('file.rb')
    File.delete('empty.rb')
  end

  describe 'read' do
    context 'When a file is given' do
      it 'returns the file content' do
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

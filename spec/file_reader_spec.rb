require_relative "../lib/file_reader"

describe FileReader do

  before do
    File.write('file.rb', 'file content')
    File.write('empty.rb', '')
  end

  after do
    File.delete('file.rb')
    File.delete('empty.rb')
  end

  describe '.read' do
    context 'when a file is given' do

      subject { FileReader.read('file.rb') }
      it { is_expected.to eql('file content') }
    end

    context 'when an empty file is given' do

      subject { FileReader.read('empty.rb') }
      it { is_expected.to eql('') }
    end
  end
end

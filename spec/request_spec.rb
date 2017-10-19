require_relative '../lib/request'
require 'webmock/rspec'
require 'json'

describe Request do

  describe '.post' do

    context 'when the request is succesful' do
      response = {
        code: '201',
        body: {
          'html_url' => 'http://someurl.com'
        }
      }

      before do
        stub_request(:post, /.*/).
          to_return(status: 201, body: {html_url: 'http://someurl.com'}.to_json)
      end

      subject { Request.post({}) }
      it { is_expected.to eql(response) }
    end

    context 'when the request fails' do

      before do
        stub_request(:post, /.*/).to_raise( Net::ProtocolError.new('someerror'))
      end

      subject { Request.post({}) }
      it { is_expected.to eql('someerror') }
    end
  end
end

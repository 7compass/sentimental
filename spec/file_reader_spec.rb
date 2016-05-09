require_relative 'spec_helper'
require_relative '../lib/file_reader'
include FileReader

describe FileReader do
  describe '#hash_from_txt' do
    subject(:answer) { FileReader.hash_from_txt('spec/test_data/test.txt') }

    it 'returns a hash from a txt file' do
      expect(answer.empty?).to be_falsey
    end

    it 'contains the data' do
      expect(answer['TEST']).to eq 1.0
      expect(answer[':(']).to eq(-1.0)
    end
  end

  describe '#hash_from_json' do
    subject(:answer) { FileReader.hash_from_json('spec/test_data/test.json') }

    it 'returns a hash from a json file' do
      expect(answer.empty?).to be_falsey
    end

    it 'contains the data' do
      expect(answer['TEST']).to eq 1.0
      expect(answer[':(']).to eq(-1.0)
    end
  end
end

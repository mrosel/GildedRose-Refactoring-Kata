require_relative '../spec_helper'

describe 'Acceptance' do
  describe "texttest output" do
    it "does not change the original IO" do
      output = `ruby texttest_fixture.rb`
      fixture_output = `cat tmp/texttest_fixture_output.txt`
      expect(output).to eq fixture_output
    end
  end
end

require "spec_helper"

describe Patterdale::ICal do
  let(:rota) { build_list(:rota, 5) }

  describe "#results" do
    let(:results) { described_class.new(rota).results }

    it "returns an iCal feed" do
      rota.each do |r|
        expect(results).to match(/DTSTART;VALUE=DATE:#{r.start_date.strftime('%Y%m%d')}/)
        expect(results).to match(/DTEND;VALUE=DATE:#{(r.end_date + 1.day).strftime('%Y%m%d')}/)
        expect(results).to match(/SUMMARY:#{r.developer_name} and #{r.ops_name} on support/)
      end
    end
  end
end

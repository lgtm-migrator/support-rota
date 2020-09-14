RSpec.describe OpsgenieTamer::Rota do
  let(:person) { double(full_name: "Geoff", username: "geoff@tubechallenge.org") }
  let(:rota) { OpsgenieTamer::Rota.new(date: Time.new(2020, 8, 8, 13, 45, 20), role: "dev", person: person) }

  describe "#==" do
    it "is true for two objects with the same date, role, and person details" do
      other_rota = OpsgenieTamer::Rota.new(date: Time.new(2020, 8, 8, 13, 45, 20), role: "dev", person: person)

      expect(other_rota).to eq(rota)
    end

    it "is false for two objects with at least one different attribute" do
      other_rota = OpsgenieTamer::Rota.new(date: Time.new(2020, 8, 9, 13, 45, 20), role: "dev", person: person)

      expect(other_rota).not_to eq(rota)
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the rota" do
      expect(rota.to_h).to eql(date: Date.new(2020, 8, 8), role: "dev", person: {name: "Geoff", email: "geoff@tubechallenge.org"})
    end
  end
end

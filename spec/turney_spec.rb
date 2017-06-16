require "spec_helper"

RSpec.describe Turney do
  it "has a version number" do
    expect(Turney::VERSION).not_to be nil
  end

  it "picks a winner" do
    expect(Turney.start(4).name).to be_a(String)
  end
end

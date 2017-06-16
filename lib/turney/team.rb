require 'json'
class Team
  attr_accessor :name, :played_bye
  def initialize(name)
    @name = name
    @played_bye = false
  end

  def bye?
    name == :bye
  end

  def to_json(pretty = false)
    {
        name: name,
        played_bye: played_bye,
        bye_team: bye?
    }.to_json(pretty)
  end

end
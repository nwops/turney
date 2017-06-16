
class Team
  attr_accessor :name, :played_bye

  def initialize(name)
    @name = name
    @played_bye = false
  end

  def bye?
    name == :bye
  end
end
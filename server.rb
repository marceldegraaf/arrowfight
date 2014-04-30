require "bundler/setup"
require "sinatra"
require "json"

class Score

  def initialize(path)
    @path = path
  end

  def as_json
    score_hash.to_json
  end

  private

  def file
    @file ||= File.open(@path)
  end

  def score_hash
    {
      zone_a_domination: value_for("ZoneA"),
      zone_b_domination: value_for("ZoneB"),
      zone_c_domination: value_for("ZoneC"),

      button_a_state: value_for("ButtonA"),
      button_b_state: value_for("ButtonB"),
      button_c_state: value_for("ButtonC"),

      team_blue_score: value_for("TeamBlue"),
      team_gold_score: value_for("TeamGold"),

      zone_a_disabled_percentage: value_for("ZoneADisabledPercentage"),
      zone_c_disabled_percentage: value_for("ZoneCDisabledPercentage")
    }
  end

  def value_for(key)
    line = lines.select { |line| line =~ /\A#{key}/i }.first

    value = if line
      line.split(":")[1]
    else
      "unknown"
    end

    value.downcase
  end

  def lines
    @lines ||= file.readlines.map(&:strip)
  end

end

get '/' do
  response.headers["Access-Control-Allow-Origin"] = "*"

  score = Score.new("/tmp/score.txt")
  score.as_json
end

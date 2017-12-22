require 'mudpot'

module Helper

  OPERATORS = Hash[YAML.load_file("#{File.dirname(__FILE__)}/operators.yml").map do |key, value|
    [key.downcase.gsub('mud_op_', ''), value]
  end].freeze

  def op
    Mudpot::Expression.new
  end

end

RSpec.configure do |config|
  config.include Helper
end

RSpec::Matchers.define :ast do |expected|
  match do |actual|
    exp = actual.is_a?(Mudpot::Expression) ? actual : Mudpot::Parser.new.parse(actual)
    exp.ast == expected
  end
end

RSpec::Matchers.define :compiled do |expected|
  match do |actual|
    exp = actual.is_a?(Mudpot::Expression) ? actual : Mudpot::Parser.new.parse(actual)
    exp.compile(Helper::OPERATORS) == expected
  end
end
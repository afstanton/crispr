# frozen_string_literal: true

require "parser/current"

module ParserHelpers
  def parse(source)
    Parser::CurrentRuby.parse(source)
  end

  def s(type, *children)
    Parser::AST::Node.new(type, children)
  end
end

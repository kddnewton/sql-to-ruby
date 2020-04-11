# frozen_string_literal: true

require 'gda'

require 'sql_to_ruby/conversions'
require 'sql_to_ruby/printer'

module SQLToRuby
  using Conversions

  def self.convert(sql)
    GDA::SQL::Parser.new.parse(sql).ast.convert
  end
end

# frozen_string_literal: true

require 'gda'

require 'sql-to-ruby/convertions'
require 'sql-to-ruby/printer'

module SQLToRuby
  using Conversions

  def self.convert(sql)
    GDA::SQL::Parser.new.parse(sql).ast.convert
  end
end

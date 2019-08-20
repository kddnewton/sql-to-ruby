# frozen_string_literal: true

require 'gda'

module SQLToRuby
  module Conversions
    refine GDA::Nodes::Expr do
      def convert
        if cond
          cond.convert
        elsif value
          value
        else
          raise 'Cannot yet understand more complex expressions'
        end
      end
    end

    refine GDA::Nodes::From do
      def convert
        targets[0].convert
      end

      def simple?
        targets.length == 1 && targets[0].simple?
      end
    end

    refine GDA::Nodes::Operation do
      def convert
        raise 'Cannot yet understand operators besides =' unless operator == '='

        left, right = operands.map(&:convert)
        "#{left}: \"#{right}\""
      end
    end

    refine GDA::Nodes::Select do
      def convert
        ruby = source

        if expr_list.length > 1 || expr_list[0].expr.value != '*'
          ruby = "#{ruby}.select(#{expr_list.map { |node| node.convert(source) }.join(', ')})"
        else
          ruby = "#{ruby}.all"
        end

        if where_cond
          ruby = "#{ruby}.where(#{where_cond.convert})"
        end

        ruby
      end

      def source
        raise 'Cannot yet understand multiple table queries' unless from.simple?
        from.convert[0...-1].capitalize
      end
    end

    refine GDA::Nodes::SelectField do
      def convert(source)
        symbol = field_name.to_sym.inspect
        return symbol unless as

        "#{source}.arel_table[#{symbol}].as(#{as})"
      end
    end

    refine GDA::Nodes::Target do
      def convert
        table_name
      end

      def simple?
        !as
      end
    end
  end

  using Conversions

  def self.convert(sql)
    GDA::SQL::Parser.new.parse(sql).ast.convert
  end
end

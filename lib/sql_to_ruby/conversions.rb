# frozen_string_literal: true

module SQLToRuby
  module Conversions
    refine GDA::Nodes::Expr do
      def convert
        if func
          func.convert
        elsif cond
          cond.convert
        elsif value
          value
        else
          raise 'Unsupported expression type'
        end
      end
    end

    refine GDA::Nodes::Function do
      def convert
        "#{function_name}(#{args_list.map(&:convert).join(', ')})"
      end
    end

    refine GDA::Nodes::Join do
      def convert(target)
        ".joins(:#{target.convert})"
      end
    end

    refine GDA::Nodes::Operation do
      def convert
        raise 'Cannot yet understand operators besides =' if operator != '='

        operands.map(&:convert).join(': ')
      end
    end

    refine GDA::Nodes::Order do
      def convert(source)
        if asc
          ":#{expr.convert}"
        else
          "#{source}.arel_table[#{expr.convert.to_sym.inspect}].desc"
        end
      end
    end

    # rubocop:disable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    refine GDA::Nodes::Select do
      def convert
        source = from.targets[0].convert[0...-1].capitalize

        Printer.print(source) do |printer|
          if expr_list.length > 1 || expr_list[0].expr.value != '*'
            printer << ".select(#{expr_list.map { |node| node.convert(source) }.join(', ')})"
          elsif from.targets.length == 1 && !where_cond && order_by.empty? && !limit_count && !limit_offset
            printer << '.all'
          end

          if from.targets.any?
            from.joins.zip(from.targets[1..]).each do |join, target|
              printer << join.convert(target)
            end
          end

          printer << ".where(#{where_cond.convert})" if where_cond

          if order_by.any?
            printer << ".order(#{order_by.map { |node| node.convert(source) }.join(', ')})"
          end

          printer << ".limit(#{limit_count.convert})" if limit_count
          printer << ".offset(#{limit_offset.convert})" if limit_offset
        end
      end
    end
    # rubocop:enable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    refine GDA::Nodes::SelectField do
      def convert(source)
        if field_name
          symbol = field_name.to_sym.inspect
          as ? "#{source}.arel_table[#{symbol}].as(#{as})" : symbol
        else
          field = "Arel.sql(\"#{expr.convert}\")"
          as ? "#{field}.as(\"#{as}\")" : field
        end
      end
    end

    refine GDA::Nodes::Target do
      def convert
        table_name
      end
    end

    refine GDA::Nodes::Unknown do
      def convert
        'Error parsing'
      end
    end
  end
end

# frozen_string_literal: true

module SQLToRuby
  class Printer
    LINE_LENGTH = 80
    attr_reader :source, :clauses

    def initialize(source, clauses = [])
      @source = source
      @clauses = clauses
    end

    def <<(clause)
      clauses << clause
    end

    def print
      if source.length + clauses.sum(&:length) <= LINE_LENGTH
        "#{source}#{clauses.join}"
      else
        "#{source}#{clauses.map { |clause| "\n  #{clause}" }.join}"
      end
    end

    def self.print(source)
      instance = new(source)
      yield instance
      instance.print
    end
  end
end

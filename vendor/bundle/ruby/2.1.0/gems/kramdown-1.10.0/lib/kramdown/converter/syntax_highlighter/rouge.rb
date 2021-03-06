# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2009-2015 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown which is licensed under the MIT.
#++
#

module Kramdown::Converter::SyntaxHighlighter

  # Uses Rouge which is CSS-compatible to Pygments to highlight code blocks and code spans.
  module Rouge

    begin
      require 'rouge'

      # Highlighting via Rouge is available if this constant is +true+.
      AVAILABLE = true
    rescue LoadError, SyntaxError
      AVAILABLE = false  # :nodoc:
    end

    def self.call(converter, text, lang, type, _unused_opts)
      opts = options(converter, type)
      lexer = ::Rouge::Lexer.find_fancy(lang || opts[:default_lang], text)
      return nil if opts[:disable] || !lexer

      formatter = (opts.delete(:formatter) || ::Rouge::Formatters::HTML).new(opts)
      formatter.format(lexer.lex(text))
    end

    def self.options(converter, type)
      prepare_options(converter)
      converter.data[:syntax_highlighter_rouge][type]
    end

    def self.prepare_options(converter)
      return if converter.data.key?(:syntax_highlighter_rouge)

      cache = converter.data[:syntax_highlighter_rouge] = {}

      opts = converter.options[:syntax_highlighter_opts].dup
      span_opts = (opts.delete(:span) || {}).dup
      block_opts = (opts.delete(:block) || {}).dup
      [span_opts, block_opts].each do |hash|
        hash.keys.each do |k|
          hash[k.kind_of?(String) ? Kramdown::Options.str_to_sym(k) : k] = hash.delete(k)
        end
      end

      cache[:span] = opts.merge(span_opts).update(:wrap => false)
      cache[:block] = opts.merge(block_opts)
    end

  end

end

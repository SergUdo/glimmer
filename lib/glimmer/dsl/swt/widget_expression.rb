require 'glimmer'
require 'glimmer/dsl/expression'
require 'glimmer/dsl/parent_expression'

module Glimmer
  module DSL
    module SWT
      class WidgetExpression < Expression
        include ParentExpression
  
        EXCLUDED_KEYWORDS = %w[shell display tab_item]
  
        def can_interpret?(parent, keyword, *args, &block)
          !EXCLUDED_KEYWORDS.include?(keyword) and
            widget?(parent) and #TODO change to composite?(parent)
            Glimmer::SWT::WidgetProxy.widget_exists?(keyword)
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::WidgetProxy.new(keyword, parent, args)
        end
      end
    end
  end
end

require 'glimmer/swt/widget_proxy'

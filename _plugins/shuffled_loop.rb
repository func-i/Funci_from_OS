require 'byebug'

class ShuffledLoop < Liquid::For

  def initialize(tag_name, markup, tokens)
    super
  end

  def render(context)
    collection = context[@collection_name]
    context[@collection_name].shuffle! if collection.is_a?(Array)
    super
  end
end

Liquid::Template.register_tag('shuffled_loop', ShuffledLoop)


class Symbol
  include Comparable

  def <=>(other)
    return unless other.kind_of?(Symbol)
    to_s <=> other.to_s
  end

  def match(pattern)
    str = to_s

    case pattern
    when Regexp
      match_data = pattern.search_region(str, 0, str.bytesize, true)
      Regexp.last_match = match_data
      return match_data.full[0] if match_data
    when String
      raise TypeError, "type mismatch: String given"
    else
      pattern =~ str
    end
  end

  alias =~ match

end unless Symbol.is_a?(Comparable)

class Module
  if RUBY_VERSION < '1.9'
    alias const? const_defined?
  else
    def const?(name)
      const_defined?(name, false)
    end
  end
end

class Struct
  alias_method :__class__, :class
end unless Struct.instance_methods.include?(:__class__)

module CSL
  module_function

  if RUBY_VERSION < '1.9'

    XML_ENTITY_SUBSTITUTION = Hash[*%w{
     & &amp; < &lt; > &gt; ' &apos; " &quot;
    }].freeze

    def encode_xml_text(string)
      string.gsub(/[&<>]/) { |match|
        XML_ENTITY_SUBSTITUTION[match]
      }
    end

    def encode_xml_attr(string)
      string.gsub(/[&<>'"]/) { |match|
        XML_ENTITY_SUBSTITUTION[match]
      }.inspect
    end
  else
    def encode_xml_text(string)
      string.encode(:xml => :text)
    end

    def encode_xml_attr(string)
      string.encode(:xml => :attr)
    end
  end
end

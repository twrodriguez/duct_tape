class Symbol
  unless method_defined?(:<=>)
    def <=>(other)
      return nil unless other.is_a?(Symbol)
      to_s <=> other.to_s
    end
  end
end

class Object
  def self.const_missing(c)
    return nil if @calling_const_missing

    # TODO: need to rewrite this in a diff way but I have no clue yet
    @calling_const_missing = true
    require Rulers.to_underscore(c.to_s)
    klass = Object.const_get(c)
    @calling_const_missing = false

    klass
  end
end

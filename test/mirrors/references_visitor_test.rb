require 'test_helper'
require 'mirrors/marker'

module Mirrors
  class ReferencesVisitorTest < MiniTest::Test
    class Victim
      def lol
        @ivar += 1 # touch one of the ivars
        to_s # send to_s
        Kernel.exit # reference another class
        foo { |bar| bar.baz } # send with block. two methods.
      end
    end

    def test_victim_class
      method = Mirrors.reflect(Victim).instance_methods.first
      refs = method.references
      assert_equal(6, refs.size)
      c1 = Marker.new(type: Marker::TYPE_CLASS_REFERENCE, message: :Kernel, file: __FILE__, line: 10)
      m1 = Marker.new(type: Marker::TYPE_METHOD_REFERENCE, message: :to_s, file: __FILE__, line: 9)
      m2 = Marker.new(type: Marker::TYPE_METHOD_REFERENCE, message: :exit, file: __FILE__, line: 10)
      m3 = Marker.new(type: Marker::TYPE_METHOD_REFERENCE, message: :foo, file: __FILE__, line: 11)
      m3 = Marker.new(type: Marker::TYPE_METHOD_REFERENCE, message: :baz, file: __FILE__, line: 11)
      f1 = Marker.new(type: Marker::TYPE_FIELD_REFERENCE, message: :@ivar, file: __FILE__, line: 8)

      assert_equal(:lol, method.name) # ensure that we have the right method
      assert(refs.include?(c1))
      assert(refs.include?(m1))
      assert(refs.include?(m2))
      assert(refs.include?(f1))
    end
  end
end

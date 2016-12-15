require 'test_helper'

module Mirrors
  class ApplicationPackageSupportTest < MiniTest::Test
    def setup
      @m = Mirrors.reflect(ClassFixture)
      super
    end

    def test_package
      act = ApplicationPackageSupport.package(@m)
      exp = Package.new('some-package')
      assert_equal(exp, act)
    end

    def test_private?
      top  = ClassFixture
      priv = ClassFixture::ClassFixtureNested
      pub  = ClassFixture::ClassFixtureNested::ClassFixtureNestedNested
      refute(ApplicationPackageSupport.private?(Mirrors.reflect(top)))
      assert(ApplicationPackageSupport.private?(Mirrors.reflect(priv)))
      refute(ApplicationPackageSupport.private?(Mirrors.reflect(pub)))
    end

    def test_visible_from?
      skip "TODO"
    end
  end
end
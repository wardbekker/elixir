Code.require_file "../test_helper", __FILE__

module FileTest
  mixin ExUnit::Case

  def expand_path_test
    "/foo/bar" = File.expand_path("/foo/bar")
    "/foo/bar" = File.expand_path("/foo/bar/")
    "/foo/bar" = File.expand_path("/foo/bar/.")
    "/foo/bar" = File.expand_path("/foo/bar/../bar")

    "/foo/bar" = File.expand_path("bar", "/foo")
    "/foo/bar" = File.expand_path("bar/", "/foo")
    "/foo/bar" = File.expand_path("bar/.", "/foo")
    "/foo/bar" = File.expand_path("bar/../bar", "/foo")
    "/bar" = File.expand_path("../bar/../bar", "/foo/../foo/../foo")

    full  = File.expand_path("foo/bar")
    ~full = File.expand_path("bar/../bar", "foo")
  end

  def join_test
    "foo/bar" = File.join("foo", "bar")
    "foo/bar/baz" = File.join(["foo", "bar", "baz"])
  end

  def split_test
    ["foo"] = File.split("foo")
    ["foo", "bar"] = File.split("foo/bar")
    ["foo", "bar", "baz"] = File.split("foo/bar/baz")
  end

  def read_info_test
    info1 = File.read_info __FILE__
    'regular = info1['type]
    true = info1.regular?
    true = info1.read?

    info2 = File.read_info File.expand_path("..", __FILE__)
    'directory = info2['type]
    true = info2.directory?

    self.assert_error 'enoent, -> File.read_info __FILE__ + ".unknown"
  end

  def read_test
    self.assert_included "object FileTest", File.read __FILE__
    self.assert_error 'enoent, -> File.read __FILE__ + ".unknown"
  end

  def regular_test
    true  = File.regular?(__FILE__)
    false = File.regular?(__FILE__ + ".unknown")
  end

  def wildcard_test
    files = File.wildcard File.expand_path("../../../lib/**/*", __FILE__)
    assert_included File.expand_path("../../../lib/code", __FILE__), files
    assert_included File.expand_path("../../../lib/code.ex", __FILE__), files
  end

  def wildcard_include_dot_test
    dotted = File.expand_path("../fixtures/.dotted.exs", __FILE__)

    files = File.wildcard File.expand_path("../fixtures/*", __FILE__)
    assert_not_included dotted, files

    files = File.wildcard File.expand_path("../fixtures/*", __FILE__), true
    assert_included dotted, files

    files = File.wildcard File.expand_path("../fixtures/**/*", __FILE__)
    assert_not_included dotted, files

    files = File.wildcard File.expand_path("../fixtures/**/*", __FILE__), true
    assert_included dotted, files
  end
end


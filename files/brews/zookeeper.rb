require "formula"

class Zookeeper < Formula
  homepage "https://zookeeper.apache.org/"
  version "3.4.6-boxen3"

  stable do
    url "http://www.apache.org/dyn/closer.cgi?path=zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz"
    sha1 "2a9e53f5990dfe0965834a525fbcad226bf93474"

    # To resolve Yosemite build errors.
    # https://issues.apache.org/jira/browse/ZOOKEEPER-2049
    if MacOS.version == :yosemite
      patch :p0 do
        url "https://issues.apache.org/jira/secure/attachment/12673210/ZOOKEEPER-2049.noprefix.branch-3.4.patch"
        sha1 "ff0e971c028050ccebd8cc7caa348ab14716d664"
      end
    end
  end

  head do
    url "https://svn.apache.org/repos/asf/zookeeper/trunk"

    # To resolve Yosemite build errors.
    # https://issues.apache.org/jira/browse/ZOOKEEPER-2049
    if MacOS.version == :yosemite
      patch :p0 do
        url "https://issues.apache.org/jira/secure/attachment/12673212/ZOOKEEPER-2049.noprefix.trunk.patch"
        sha1 "79ed0793e4693c9bbb83aad70582b55012f19eac"
      end
    end

    depends_on "ant" => :build
    depends_on "cppunit" => :build
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "perl", "Build Perl bindings"

  depends_on :python => :optional

  def install
    # Don't try to build extensions for PPC
    if Hardware.is_32_bit?
      ENV["ARCHFLAGS"] = "-arch #{Hardware::CPU.arch_32_bit}"
    else
      ENV["ARCHFLAGS"] = Hardware::CPU.universal_archs.as_arch_flags
    end

    if build.head?
      system "ant", "compile_jute"
      system "autoreconf", "-fvi", "src/c"
    end

    cd "src/c" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--without-cppunit"
      system "make", "install"
    end

    cd "src/contrib/zkpython" do
      system "python", "src/python/setup.py", "build"
      system "python", "src/python/setup.py", "install", "--prefix=#{prefix}"
    end if build.with? "python"

    cd "src/contrib/zkperl" do
      system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                                    "--zookeeper-include=#{include}",
                                    "--zookeeper-lib=#{lib}"
      system "make", "install"
    end if build.include? "perl"

    rm_f Dir["bin/*.cmd"]

    if build.head?
      system "ant"
      libexec.install Dir["bin", "src/contrib", "src/java/lib", "build/*.jar"]
    else
      libexec.install Dir["bin", "contrib", "lib", "*.jar"]
    end
  end

  plist_options :manual => "zkServer start"
end

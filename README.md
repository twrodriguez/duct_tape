duct_tape
=========

Utility Patchwork Library for Ruby 1.8.7+

Getting Started
---------------

Install the gem.

    $ sudo gem install duct_tape

Require with rubygems.

    require 'rubygems'
    require 'duct_tape'

Because duct_tape requires the excellent [facets](https://github.com/rubyworks/facets)
and [algorithms](https://github.com/kanwei/algorithms) gems, the core classes have become
much more malleable. Any overridden methods have maintained their original functionality.

Supported Platforms
-------------------

- Mac OSX, Linux, FreeBSD, Solaris, Windows XP or Later (mingw)
- Ruby Versions 1.8.7+
- MRI, YARV, RubyEE, Rubinius, JRuby

Requirements
------------

- Ruby 1.8.7 (MRI / RubyEE / Rubinius):
  - [facets](https://github.com/rubyworks/facets) gem
  - [algorithms](https://github.com/kanwei/algorithms) gem
- Ruby 1.9+:
  - [facets](https://github.com/rubyworks/facets) gem
  - [algorithms](https://github.com/kanwei/algorithms) gem
- JRuby:
  - [facets](https://github.com/rubyworks/facets) gem

Core Extensions
---------------

Array, TrueClass, FalseClass, DateTime, Dir, File, Hash, Kernel, Numeric, Object,
Range, Regexp, String, and Time have patches in duct_tape. Here are a few examples:

    # Array
    ["a","b","c"].to_h                        #=> {0=>"a", 1=>"b", 2=>"c"}
    [[1,2], [3,4]].to_h                       #=> {1=>2, 3=>4}
    [{1 => 2}, {3 => 4}].to_h                 #=> {1=>2, 3=>4}
    [{"name" => 1, "value" => 2},
     {"name" => 3, "value" => 4}].to_h        #=> {1=>2, 3=>4}
    [{:x => 1, :y => 2},
     {:x => 3, :y => 4}].to_h(:x, :y)         #=> {1=>2, 3=>4}
    [{1 => 2, 3 => 4}, {1 => 4}].to_h         #=> {1=>[2, 4], 3=>4}
    [1,2,3,4,5,6,7].chunk(3)                  #=> [[1, 2, 3], [4, 5, 6], [7]]
    [1,2] * [3,4]                             #=> [[1, 3], [1, 4], [2, 3], [2, 4]]
    [0,1] ** 0                                #=> []
    [0,1] ** 1                                #=> [[0], [1]]
    [0,1] ** 2                                #=> [[0, 0], [0, 1], [1, 0], [1, 1]]
    [1,1,1].unanimous?                        #=> true
    [1,1,2].unanimous?                        #=> false
    [1,1,1].unanimous?(1)                     #=> true
    [1,1,1].unanimous?(2)                     #=> false
    [1,1,1].unanimous? { |i| i != 2 }         #=> true
    [1,1,1].unanimous?(4) { |i| i + 3 }       #=> true

    # Range
    (1..7).chunk(3)                           #=> [[1, 2, 3], [4, 5, 6], [7]]

    # Hash
    {1=>{2=>[3]}}.deep_merge({1=>{2=>[4]}})   #=> {1=>{2=>[3, 4]}}
    {1=>2, 2=>3, 3=>4, 4=>5}.chunk(2)         #=> [{1=>2, 2=>3}, {3=>4, 4=>5}]

    # Regexp
    /ll/.invert                               #=> /\A(?:(?!ll).)+\z/
    "hello" =~ /ll/                           #=> 2
    "hello" =~ /ll/.invert                    #=> nil
    "hello" =~ /ll/.invert.invert             #=> 2

    # String
    "lorem ipsum".word_wrap(3)                #=> "lor\nem\nips\num\n"
    "1234567890".chunk(3)                     #=> ["123", "456", "789", "0"]
    "%{x} %{y}" % {:x => 3, :y => 4}          #=> "3 4"

    # Time
    Time.duration(61621)                      #=> "17 hours, 7 minutes and 1 second"

Platform Detection
------------------

    # Kernel (on Fedora)
    detect_platform                           #=> {:arch=>"i386",
                                              #    :hostname=>"Teruhide",
                                              #    :install_cmd=>"yum install -y",
                                              #    :install_method=>"install",
                                              #    :interpreter=>"jruby",
                                              #    :interpreter_language=>"java",
                                              #    :ipv4=>"192.168.1.24",
                                              #    :local_install_cmd=>"yum localinstall -y",
                                              #    :n_cpus=>4,
                                              #    :os_distro=>"Fedora",
                                              #    :os_nickname=>"Verne",
                                              #    :os_version=>"16",
                                              #    :pkg_arch=>"i386",
                                              #    :pkg_format=>"rpm",
                                              #    :platform=>"linux",
                                              #    :ram=>2106052608,
                                              #    :ruby_version=>"1.8.7"}

    # Kernel (on Windows)
    detect_platform                           #=> {:arch=>"i386",
                                              #    :hostname=>"TIM-84DDD2CE6C6",
                                              #    :install_cmd=>"install",
                                              #    :install_method=>"install",
                                              #    :interpreter=>"mri",
                                              #    :interpreter_language=>"c",
                                              #    :ipv4=>"10.0.2.15",
                                              #    :n_cpus=>8,
                                              #    :os_distro=>"XP Professional",
                                              #    :os_nickname=>"Microsoft Windows XP Professional",
                                              #    :os_version=>"5.1.2600",
                                              #    :platform=>"windows",
                                              #    :ram=>2146435072,
                                              #    :ruby_version=>"1.9.3"}

    # Kernel (on OpenSolaris)
    detect_platform                           #=> {:arch=>"i386",
                                              #    :hostname=>"opensolaris",
                                              #    :install_cmd=>"pkg install",
                                              #    :install_method=>"install",
                                              #    :interpreter=>"mri",
                                              #    :interpreter_language=>"c",
                                              #    :ipv4=>"192.168.1.70",
                                              #    :n_cpus=>8,
                                              #    :os_distro=>"OpenSolaris",
                                              #    :os_nickname=>"OpenSolaris 2009.06",
                                              #    :os_version=>"5.11",
                                              #    :platform=>"solaris",
                                              #    :ram=>2147483648,
                                              #    :ruby_version=>"1.8.7"}


AutoassociativeArray
--------------------

In addition to core extensions, duct_tape includes a new container class called an
AutoassociativeArray. Think of it as a cross between a relational database and a
bidirectional hash. It also adds partial matching capabilities, though the runtime
of partial matches can explode if abused in the worst case.

    aa = Containers::AutoassociativeArray.new
    aa << [1,2,3] << [2,3,4] << [3,4,5]       #=> [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
    aa[1]                                     #=> [1, 2, 3]
    aa[2]                                     #=> [[1, 2, 3], [2, 3, 4]]
    aa[3]                                     #=> [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
    aa[4]                                     #=> [[2, 3, 4], [3, 4, 5]]
    aa[5]                                     #=> [3, 4, 5]
    aa[2,3]                                   #=> [[1, 2, 3], [2, 3, 4]]
    aa[2,3,4]                                 #=> [2, 3, 4]
    aa[2,5]                                   #=> []
    aa.partial_match(1,4)                     #=> [[2, 3, 4], [3, 4, 5]]
    aa.partial_match(1,5)                     #=> [[1, 2, 3], [3, 4, 5]]
    aa.partial_match(1,3,5)                   #=> [[1, 2, 3], [3, 4, 5]]
    aa.partial_match(1,4,5)                   #=> [3, 4, 5]
    aa.partial_match(2,4)                     #=> [2, 3, 4]
    aa.partial_match(2,5)                     #=> [[1, 2, 3], [2, 3, 4]]

Partial matches return the set of arrays with the most matched elements from the
query.

License
-------

2-Clause BSD License

Copyright (c) 2011-2012, Tim Rodriguez ([twrodriguez](https://github.com/twrodriguez))
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

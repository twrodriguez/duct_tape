require 'rubygems'
require 'backports'
require 'facets/kernel'
require 'facets/enumerable'
require 'facets/array'
require 'facets/dir'
require 'facets/file'
require 'facets/hash'
require 'facets/numeric'
require 'facets/range'
require 'facets/regexp'
#########################################
#require 'facets/string'
#########################################
# Can't require facets/string directly because there are no guards
# against re-defining certain functions
require 'facets/kernel/require_relative'

require 'facets/string/acronym.rb'
require 'facets/string/align.rb'
require 'facets/string/bytes.rb'
require 'facets/string/camelcase.rb'
require 'facets/string/capitalized.rb'
require 'facets/string/characters.rb'
require 'facets/string/cleanlines.rb'
require 'facets/string/cleave.rb'
require 'facets/string/cmp.rb'
require 'facets/string/compress_lines.rb'
require 'facets/string/divide.rb'
require 'facets/string/each_char.rb'
require 'facets/string/each_word.rb'
require 'facets/string/edit_distance.rb'
require 'facets/string/end_with.rb'
require 'facets/string/exclude.rb'
require 'facets/string/expand_tab.rb'
require 'facets/string/file.rb'
require 'facets/string/fold.rb'
require 'facets/string/indent.rb'
require 'facets/string/index_all.rb'
require 'facets/string/interpolate.rb'
require 'facets/string/lchomp.rb'
require 'facets/string/lines.rb'
require 'facets/string/line_wrap.rb'
require 'facets/string/lowercase.rb'
require 'facets/string/margin.rb'
require 'facets/string/methodize.rb'
require 'facets/string/modulize.rb'
require 'facets/string/mscan.rb'
require 'facets/string/natcmp.rb'
require 'facets/string/nchar.rb'
require 'facets/string/newlines.rb'
require 'facets/string/op_div.rb'
require 'facets/string/op_sub.rb'
require 'facets/string/outdent.rb'
require 'facets/string/pathize.rb'
require 'facets/string/quote.rb'
require 'facets/string/random_binary.rb'
require 'facets/string/range.rb'
require 'facets/string/range_all.rb'
require 'facets/string/range_of_line.rb'
require 'facets/string/rewrite.rb'
require 'facets/string/shatter.rb'
require 'facets/string/similarity.rb'
require 'facets/string/snakecase.rb'
require 'facets/string/splice.rb'
require 'facets/string/squish.rb'
require 'facets/string/store.rb'
require 'facets/string/subtract.rb'
require 'facets/string/tab.rb'
require 'facets/string/tabto.rb'
require 'facets/string/titlecase.rb'
require 'facets/string/to_re.rb'
require 'facets/string/underscore.rb'
require 'facets/string/unfold.rb'
require 'facets/string/unindent.rb'
require 'facets/string/unquote.rb'
require 'facets/string/uppercase.rb'
require 'facets/string/variablize.rb'
require 'facets/string/words.rb'
require 'facets/string/word_wrap.rb'
require 'facets/string/xor.rb'
#########################################
require 'facets/symbol'
require 'facets/time'
require 'facets/uri'

Dir[__DIR__("ext", "*.rb")].each { |f| require f }

if gem_installed?('algorithms')
  require 'algorithms'
  automatic_require "algorithms"
end

automatic_require

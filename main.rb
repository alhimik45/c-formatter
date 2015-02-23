filename = ARGV[0] or abort("No file specified")
code = File.read(filename)
current_indent = 0
prepared_code = code.gsub(/\n(\s*)\{/, "{\n\\1 ").
						gsub(/\n(\s*)\}/, "}\n\\1 ").
						gsub(/\{([^\{;\}\n])/, "{\n\\1").
						gsub(/\}([^\{;\}\n])/, "}\n\\1").
						gsub(/\s*\n\s*/, "\n")
lines = prepared_code.split("\n")

indented_lines = lines.map { |line|  
	line = "    " * current_indent + line
	m = (line+"\n").match(/[;\{\}]+\s*\n/)
	if m.nil?
		next line
	end
	brackets_str = m[0]
	current_indent += brackets_str.
						split("").
						reduce(0) { |ind, symb|
		case symb
		when "{"
			next ind += 1
		when "}"
			next ind -= 1
		else
			next ind
		end
	}
	line
}
max_str_size = indented_lines.map {|el| el.size }.max
max_indentation = max_str_size + 2
puts indented_lines.map { |line|
	m = (line+"\n").match(/[;\{\}]+\s*\n/)
	if m.nil?
		next line
	end
	brackets_str = m[0]
	line[0..m.offset(0)[0]-1] + " " * (max_str_size - m.offset(0)[0]) + brackets_str.chomp
}.join("\n")

# $stderr.puts m.offset(0)
# 	line[0..m.offset(0)[0]-1] + " " * (max_str_size - m.offset(0)[0]) + brackets_str.chomp






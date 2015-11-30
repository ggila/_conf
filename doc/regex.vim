:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]
For each line in [range] replace a match of {pattern} with {string}.

range:
	a,b : between line a and line b
	number : an absolute line number
	. : current line
	$ : last line of the file
	% : the whole file, same as 1,$
	't : position of mark "t"
	/pattern[/] the next line where text "pattern" matches
	?pattern[?] the previous line where text "pattern" matches
	\/ the next line where the previously used search pattern matches
	\? the previous line where the previously used search pattern matches
	\& the next line where the previously used substitute pattern matches

flag :
	c : ask for confirmation
	g : replace all occurences in the line
	i/I : ignore/force case
	 : report the number of matches, do not subsitute

quantifier (greedy):
	* : matches 0 or more of the preceding characters, ranges or metacharacters, * matsches everything, including empty lines
	\+ : matches 1 or more of the preceding characters, ranges or ...
	\= : matches 0 or 1 of the preceding characters, ranges or ...
	\{n,m} : matches from n to m of the preceding characters, ranges or ...
	\{n} : matches exactly n times of the preceding characters, ranges or ...
	\{,m} : matches at most m of the preceding characters, ranges or ...
	\{n,} : matches at least m of the preceding characters, ranges or ...

replacement part:
	\0 the whole matched pattern
	\1 the matched pattern in first pair of \(\)
	\2 the matched pattern in second pair of \(\)
	...
	\9 the matched pattern in ninth pair of \(\)
	~ the previsous substitute string
	\L the following characters are made lowercase
	\U the following characters are made uppercase
	\E or \e  end of \U and \L
	\r split line in two as this point

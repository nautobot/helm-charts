# Enable all rules by default
all

# `mdl` isn't respecting frontmatter with a `title` directive as a valid top level header
exclude_rule 'MD002'

# Nested lists should be indented with four spaces.
rule 'MD007', :indent => 4

# Extend line length, since each sentence should be on a separate line.
rule 'MD013', :line_length => 99999

# CHANGELOGs have a lot of "duplicate heading" findings
exclude_rule 'MD024'

# Allow question and exclamation mark in heading
rule 'MD026', :punctuation => '.,;:。，；：'

# Ordered lists on GitHub should be 1,2,3 not 1,1,1
rule 'MD029', :style => 'ordered'

# Allow in-line HTML
exclude_rule 'MD033'

# Helm-docs doesn't inject the requirement URLs correctly but is automated so we must ignore
exclude_rule 'MD034'

# `mdl` isn't respecting frontmatter sections as valid first lines
exclude_rule 'MD041'

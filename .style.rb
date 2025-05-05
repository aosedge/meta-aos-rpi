all
# for readability in editor force ordered lists
rule 'MD029', :style => 'ordered'
# allow some formatting that GitHub recommends
rule 'MD033', :allowed_elements => 'sub, sup, ins'
# set 120 characters limit
rule 'MD013', :line_length => 120

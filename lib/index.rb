require "rubygems"
require "mustache"
require "lib/roadmap"
require "bibtex"
require "bibtex/parser"

r = Roadmap.new("src")
p = BibTeX::Parser.new({})
r.add_bib File.read("src/AgilePractices.bib")

Mustache.template_file = "views/biblio.tmpl"
m = Mustache.new
m[:parts] = r.all
File.open("src/biblio.ham","w") {|f| f.write m.render}

Mustache.template_file = "views/index.tmpl"

m = Mustache.new
m[:parts] = r.all_by_alpha
m[:order] = "ordre alphabétique"
File.open("src/index.ham","w") {|f| f.write m.render}
File.open("src/index_alpha.ham","w") {|f| f.write m.render}

m = Mustache.new
m[:parts] = r.all_by_type
m[:order] = "type"
File.open("src/index_type.ham","w") {|f| f.write m.render}

Mustache.template_file = "views/dash.tmpl"
m = Mustache.new
m[:parts] = r.all_by_type.map {|part| {:group => part[:group]+"s", :full => part[:values].select{|v|v["full"]}.length, :total => part[:values].length}}
m[:parts] << {:group => "Total", :full => r.all.select{|v|v["full"]}.length, :total => r.all.length}
m[:parts].each {|each| each[:pct] = sprintf( "%0.0f",each[:full]*100.0/each[:total])}
File.open("src/dash.ham","w") {|f| f.write m.render}

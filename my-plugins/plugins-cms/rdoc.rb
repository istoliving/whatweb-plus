Plugin.define do
name "rdoc"
authors [
"winezero",

]
version "0.1"
matches [
{:offset=>1, :regexp=>/Generated by <a href="https:\.\.ruby\.github\.io\.rdoc\.">RDoc<\.a> ([\d.]*\d)/},
{:offset=>1, :regexp=>/Generated by <a[^>]+href="https?:..rdoc\.rubyforge\.org[^>]+>RDoc<.a> ([\d.]*\d)/},
{:regexp=>/<link[^>]+href="[^"]*rdoc-style\.css/},
]
end
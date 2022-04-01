Plugin.define do
name "cgit"
authors [
"Fabian Affolter <fabian@engineering.ch>", 

]
version "0.1"
description "A web frontend for git repositories written in C."
website "http://git.zx2c4.com/cgit/"
matches [
{:name=>'meta generator',
:text=>"<meta name='generator' content='cgit v([^\s]+)'\/>"},
{:regexp=>/<[^>]+id='cgit/},
{:regexp=>/^cgit v([\d.a-z-]+)$/,:offset=>1, :search=>'body'},
{:regexp=>/generated by <a href='http:..git\.zx2c4\.com.cgit.about.'>cgit v([\d.a-z-]+)<.a>/,:offset=>1},
{:text=>"<div class='footer'>Copyright &copy; 2000 &ndash; 20[\d]{2} Jason A. Donenfeld. All Rights Reserved.</div>"},
{:text=>"<div id='cgit'><table id='header'>"},
{:text=>"<link rel='stylesheet' type='text/css' href='/cgit.css'/>"},
]
passive do
m=[]
if @body =~ /<meta name='generator' content='cgit v([^\s]+)'\/>/
version = @body.scan(/<meta name='generator' content='cgit v([^\s]+)'\/>/)[0][0]
m << { :version=>version }
end
m
end
end

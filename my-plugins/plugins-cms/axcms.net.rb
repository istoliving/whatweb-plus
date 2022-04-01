Plugin.define do
name "axcms.net"
authors [
"Brendan Coles <bcoles@gmail.com>", 

]
version "0.1"
description "AxCMS.net - the free ASP.NET CMS by Axinom"
website "http://en.axcms.net/"
dorks [
'"powered by axcms"'
]
matches [
{:regexp=>/Build and published by AxCMS.net | powered by Axinom/},
{:text=>'<div style="text-align:center;width:100%;"><a href="http://axcms.net" target="_blank"><img src="http://axcms.net/upload/poweredby_150x25_13871.png" height="25" width="150" alt="Powered by AxCMS.net" style="height:25px;width:150px;border-width:0px;" /></a></div></form>'},
{:version=>/<!-- Generated by AxCMS.net ([\d\.]{1,15}) -->/},
{:version=>/<meta name="GENERATOR" content="AxCMS.net ([\d\.]{1,15})" \/>/},
{:version=>/<meta name="GENERATOR" content="AxCMS.net ver([\d\.]{1,15})">/},
]
passive do
m=[]
m << { :version=>@headers['x-powered-by'].scan(/AxCMS.net ([\d\.]+)/)[0] } if @headers['x-powered-by'] =~ /AxCMS.net ([\d\.]+)/
m
end
end

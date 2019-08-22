#!/usr/bin/env bash
#
# Docset generator for Sphinx readthedocs documentations
#

# Variables
current_dir=`echo $(pwd)`
doc=$1

# Install requirments
apt update -q && apt install -q -y python3 python3-pip python3-venv unzip
go get -u github.com/aktau/github-release

# Create Python venv
python3 -m venv env
source env/bin/activate
pip3 install doc2dash

# Download docs
wget -q "https://readthedocs.org/projects/$doc/downloads/htmlzip/latest/" -O docs.zip
unzip -q docs.zip -d docs

# Create docset
cd $current_dir/docs/
doc2dash -A */ -n $doc -i $current_dir/icon.png -f
mv ~/Library/Application\ Support/doc2dash/DocSets/$doc.docset .
tar -cvzf $doc.docset.tgz $doc.docset > /dev/null 
mv $doc.docset.tgz $current_dir
cd $current_dir

# Upload to GitHub
$GOPATH/bin/github-release upload -u dash-docsets -r $doc-docset -t "latest" -n $doc.docset-$(date +%d.%m.%Y-%R).tgz -f $doc.docset.tgz

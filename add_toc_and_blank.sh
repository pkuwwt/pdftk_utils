#!/bin/bash

get_pdf_pages() {
	pdftk $1 dump_data | grep NumberOfPages | sed 's/NumberOfPages: //g'
}

# insert_pdf_after inserted.pdf dest.pdf srcRange destPageNo out.pdf
# insert_pdf_after inserted.pdf dest.pdf 1-2 3 out.pdf
# all numbers are 1-based
insert_pdf_after() {
	echo A=$1 B=$2 cat B1-$4 A$3 B`expr $4 + 1`-end output $5
	pdftk A=$1 B=$2 cat B1-$4 A$3 B`expr $4 + 1`-end output $5
}

# reverse order
missing_pages="379 346 301 242 221 200 169 92 77"

last=G*.pdf
next=tmp.pdf
for i in $missing_pages; do
	insert_pdf_after blank.pdf $last 1-1 $i tmp-$i.pdf
	last=tmp-$i.pdf
done


# dump file from: pdftk src.pdf dump_data_utf8 >dump.txt
# bookmarks in dump file
# 
#    NumberOfPages: 559
#    BookmarkBegin
#    BookmarkTitle: Cover
#    BookmarkLevel: 1
#    BookmarkPageNumber: 1
#    BookmarkBegin
#    BookmarkTitle: Preface
#    BookmarkLevel: 1
#    BookmarkPageNumber: 6
#    PageMediaBegin
#
pdftk $last update_info_utf8 dump2.txt output out.pdf

for i in $missing_pages; do
	rm -f tmp-$i.pdf
done


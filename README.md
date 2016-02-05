#Markdownify

This is a simple ruby script that converts HTML WordpressDotCom posts that have been imported with [Jekyll-Import](http://import.jekyllrb.com/docs/wordpressdotcom/) into Markdown. It renders only the following HTML elements in Markdown:

* paragraphs
* blockquotes
* links
* emphasis (aka *italics*)
* front-matter (only `layout:` and `title:`; no `tags:`, `date:`, etc.)

This means Markdownify does NOT render images, inline code, bolded text, lists, tables, etc. The reason for Markdownify's limited capabilities is that I wrote it with my blog posts in mind; and they're pretty simple.

##Using Markdownify

Markdownify takes in `.html` files and outputs new `.md` files of the same names. Load up the script in Terminal and pass in your `.html` files as arguments, all at once or one at a time.
```
#All at once:
$ ruby markdownify.rb test_posts/*.html

#One at a time:
$ ruby markdownify.rb test_posts/post_1.html #=> post_1.md
```
New `.md` files will be created alongside your old `.html` files. Be sure to check them for errors, since HTML made with Wordpress's web app is usually pretty messy.

###Images, Other HTML Elements & Stuff

If there are images in any of your `.html` files, the line on which they occur will be rendered as `***THERE WAS AN IMAGE HERE***`. I did this because my blog posts usually don't have images. It would be pretty easy to make Markdownify support images, so, if you want to, fork it... or something.

Other HTML elements will be either rendered as they are or not rendered at all - it depends on where they occur in the line.

Also, if you want to keep your tags or something, just modify the #front_matter method and consider forking it.

##Apology

I've only been coding for a couple months, so be nice and thanks for reading!

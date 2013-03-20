# 03.19.2013 Write to STDOUT an HTML page with links to all the Modern JavaScript sample page.
# Run against sample archive: http://www.larryullman.com/downloads/modern_javascript_scripts.zip


puts <<HTMLHEAD
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Modern JavaScript</title>
    <!--[if lt IE 9]>
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
</head>
<body>
<H1>Modern JavaScript Sample Pages</H1>
<P><A HREF="http://www.larryullman.com/books/modern-javascript-develop-and-design/">Modern JavaScript: Develop and Design</A> by <A HREF="http://www.larryullman.com/">Larry Ullman</A></P>
HTMLHEAD

# Represent each chapter's example code as an ordered list of html pages.
# dirName -- The base name of the directory for a particular chapter.
#            Used to build URL link.
# title -- User-friendly name for the chapter. Displayed for the user.
# examplesPages -- Array containing base names for HTML pages in the chapter directory.
class Chapter
	attr_reader :dirName, :title, :examplePages

	def initialize(dirName, title)
		@dirName = dirName
		@title = title
		@examplePages = Array.new(0)
	end

	def addExamplePage(htmlPageName)
		@examplePages.push(htmlPageName)
	end

	def examplePages?
		(@examplePages.length > 0)
	end
end
chapters = Array.new(0)

# Home folder of the examples is either the current directory or
# specified by 1st command line arg.
# We ignore case of invalid directory.
homeDir = (ARGV.length > 0) ? ARGV[0] : "." 
if (File.exist?(homeDir))

	# Populate the collection of sample HTML pages by iterating through the top level folders.
	# There is folder for each chapter, with names like "ch##", where ## is the chapter number.
	#homeDir = "C:\\xampp\\htdocs\\ModernJS"
	Dir.new(homeDir).entries.each do | chapterBase |
		chapterPath = homeDir + File::SEPARATOR + chapterBase
		#print chapterPath, File.directory?(chapterPath), "\n"

		# Skip the current & parent diretory that are included in the directory listing.
		if (File.directory?(chapterPath) && !chapterBase.start_with?("."))

			# Convert base chapter name into a human-friendly name
			# e.g. "ch04" --> "Chapter 4"
			friendlyChapterTitle = "Chapter %d" % chapterBase[2,2].to_i()
			chapterExamples = Chapter.new(chapterBase, friendlyChapterTitle)

		 	# Iterate through list of HTML pages in each chapter folder.		
			Dir.new(chapterPath).entries.each do | baseName |
				fullFilePath = chapterPath + File::SEPARATOR + baseName
				if (File.file?(fullFilePath) && baseName.end_with?(".html"))
					#puts fullFilePath
					chapterExamples.addExamplePage(baseName)
				end
			end

			# Collect chapter's sample pages data
			chapters.push(chapterExamples)

		end
	end
end

# Output links to sample pages as HTML lists
chapters.each do |e|
	if (e.examplePages?) 
		puts "<h2>" + e.title + "</h2>"
		puts "<ul>"
		e.examplePages.each do |page|
			puts "<li><a href=\"" + e.dirName + "/" + page + "\">" + page + "</a></li>"
		end
		puts "</ul>"
	end
end

# But of course chapter 15's HTML pages are not in the same place
# as the others, so we'll just hard code the link.
puts <<HTMLCH15
<H2>Chapter 15</H2>
<ul>
<li><a href="ch15/htdocs/index.html">index.html</li>
<li><a href="ch15/mysqli_connect.php">mysqli_connect.php</li>
</ul>
HTMLCH15
 
puts <<HTMLEND
</body>
</html>
HTMLEND
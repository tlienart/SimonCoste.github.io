function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

@delay function hfun_post(name)
  url = joinpath("/posts/", name[1]*".md")
  surl = strip(url, '/')
  titlep = pagevar(surl, :titlepost)
  dateofp = pagevar(surl, :date)
  descr = pagevar(surl, :abstract)
  print(titlep, "\n", dateofp, "\n", descr, "\n")
  io = IOBuffer()
  write(io, """<ul class="blog-posts">""")
  write(io, """<b><a href="$url">$titlep</a></b> &nbsp; <i> ($dateofp) </i>""")
  write(io, """<li><i class="description">$descr</i></li>""")
  write(io, "</ul>")
  return String(take!(io))
end

function hfun_recentblogposts()

  list = readdir("posts")
  filter!(f -> endswith(f, ".md"), list)
  dates = [stat(joinpath("blog", f)).mtime for f in list]
  perm = sortperm(dates, rev=true)

  io = IOBuffer()
  write(io, """<ul class="blog-posts">""")

  for (i, post) in enumerate(list[perm])
    
    ps  = splitext(post)[1]
    write(io, "<li>")
    url = "/posts/$ps/"
    surl = strip(url, '/')
    titlepost = pagevar(surl, :titlepost)
    dateofpost = pagevar(surl, :date)
    description = pagevar(surl, :abstract)

    write(io, """<b><a href="$url">$titlepost</a></b> &nbsp; <i> ($dateofpost) </i>""")
    write(io, """<li><i class="description">$description</i></li>""")
  end
  write(io, "</ul>")
  return String(take!(io))
end

function hfun_blogposts()
  today = Dates.today()
  curyear = year(today)
  curmonth = month(today)
  curday = day(today)

  list = readdir("posts")
  filter!(endswith(".md"), list)
  function sorter(p)
      ps  = splitext(p)[1]
      url = "/posts/$ps/"
      surl = strip(url, '/')
      pubdate = pagevar(surl, :published)
      if isnothing(pubdate)
          return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
      end
      return Date(pubdate, dateformat"yyyy-mm-dd")
  end
  sort!(list, by=sorter, rev=true)

  io = IOBuffer()
  write(io, """<ul class="blog-posts">""")
  for (i, post) in enumerate(list)
      if post == "index.md"
          continue
      end
      ps  = splitext(post)[1]
      write(io, "<li><span><i>")
      url = "/posts/$ps/"
      surl = strip(url, '/')
      title = pagevar(surl, :title)
      pubdate = pagevar(surl, :published)
      description = pagevar(surl, :rss)
      if isnothing(pubdate)
          date = "$curyear-$curmonth-$curday"
      else
          date = Date(pubdate, dateformat"yyyy-mm-dd")
      end
      write(io, """$date</i></span><b><a href="$url">$title</a></b>""")
      write(io, """<li><i class="description">$description</i></li>""")
  end
  write(io, "</ul>")
  return String(take!(io))
end

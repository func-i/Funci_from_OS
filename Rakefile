desc "remove /_site"

task :clear_site do
  puts "********** Remove _site/\n\n"
  puts %x{rm -rf _site}
end

desc "compile and run the site"
task :default => [:clear_site] do
  pids = [
    spawn("jekyll serve -w") # put `auto: true` in your _config.yml
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end

desc "compile and push the site to gh-pages branch of development repo"
task :staging => [:clear_site] do
  puts "********** Building files into _site/\n\n"
  puts %x{jekyll build}

  commit_message = "Site update at #{Time.now.utc}"
  dev_repo = "https://github.com/func-i/Funci_from_OS.git"

  puts "********** CD into _site, commit change, and push to gh-pages branch\n\n"
  puts %x{
    cd _site &&
    rm CNAME &&
    git init &&
    git add . &&
    git commit -m '#{commit_message}' &&
    git remote add origin #{dev_repo} &&
    git push origin master:refs/heads/gh-pages --force
  }
end

desc "compile and push the site to master branch of production repo"
task :deploy, [:path_to_gh_pages_dir] => [:clear_site] do |t, args|
  path_to_gh_pages_dir = args[:path_to_gh_pages_dir]
  last_commit_message  = `git log -1 --pretty=%B`
  puts "Last commit message: #{last_commit_message}"

  puts "********** Building files into _site/\n\n"
  puts %x{jekyll build}

  puts "********** Copying _site/ files to gh-pages dir\n\n"
  %x{cp -r _site/* #{path_to_gh_pages_dir}}

  puts "********** CDing into #{path_to_gh_pages_dir}, committing change, and pushing to master\n\n"
  puts %x{cd #{path_to_gh_pages_dir} && git pull origin master && git add . && git commit -m '#{last_commit_message}' && git push origin master}
end


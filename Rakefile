desc "compile and run the site"
task :default do
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

desc "compile and push the site to master of gh-pages repo"
task :deploy, [:path_to_gh_pages_dir] do |t, args|
  path_to_gh_pages_dir = args[:path_to_gh_pages_dir]
  last_commit_message  = `git log -1 --pretty=%B`
  puts "Last commit message: #{last_commit_message}"

  puts "********** Building files into _site/\n\n"
  puts %x{jekyll build}

  puts "********** Copying _site/ files to gh-pages dir\n\n"
  %x{cp -r _site/* #{path_to_gh_pages_dir}}

  puts "********** CDing into #{path_to_gh_pages_dir}, committing change, and pushing to master\n\n"
  puts %x{cd #{path_to_gh_pages_dir} && git add . && git commit -m '#{last_commit_message}' && git push origin master}
end
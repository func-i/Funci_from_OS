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

  puts "\n\nBuilding files into _site/.\n"
  %x{jekyll build}

  puts "\n\nCopying _site/ files to gh-pages dir.\n"
  %x{cp -r _site/* #{path_to_gh_pages_dir}}

  puts "\n\nCDing into #{path_to_gh_pages_dir}, committing change, and pushing to master./\n"
  %x{cd #{path_to_gh_pages_dir}}
  %x{git commit -am '#{last_commit_message}' && git push origin master}
end
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
task :deploy, [:path_to_gh_pages_dir] do |t, path_to_gh_pages_dir|
  # `git log -1 --pretty=%B`

  pids = [
    spawn("jekyll serve"),
    spawn("cp -r _site/* #{path_to_gh_pages_dir}"),
    spawn("git commit -am 'test build'"),
    spawn("git push origin master")
  ]
 
  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end
end
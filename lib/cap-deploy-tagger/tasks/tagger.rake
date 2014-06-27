namespace :deploy do
  
  desc "Tag deployed release"
  task :tag do
    run_locally do
      if ENV['SKIP_DEPLOY_TAGGING'] || fetch(:skip_deploy_tagging, false)
        info "[cap-deploy-tagger] Skipped deploy tagging"
      else
        tag_name = "#{fetch(:deploy_tag, "deployed")}_#{fetch(:stage)}"
        latest_revision = fetch(:current_revision)
        user_name = `git config --get user.name`.chomp
        user_email = `git config --get user.email`.chomp
        tag_message = fetch(:deploy_tag_message, "Deployed by #{user_name} (#{user_email}) as release #{release_timestamp}")
        strategy.git "tag -f #{tag_name} #{latest_revision} -m \"#{tag_message}\""
        strategy.git "push -f --tags"
        info "[cap-deploy-tagger] Tagged #{latest_revision} with #{tag_name}"
      end
    end
  end
  
  after :cleanup, 'deploy:tag'
  
end

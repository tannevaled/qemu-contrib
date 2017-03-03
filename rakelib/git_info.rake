require 'awesome_print'
# Set the source control revision similar to subversion to use in 'c'
# files as a define.
# You must build in the master branch otherwise the build branch will
# be prepended to the revision and/or "dirty" appended. This is to
# clearly ID developer builds.
namespace :git do
  task :info do

    REPO_REVISION_     = `git rev-list HEAD --count`.strip
    BUILD_BRANCH       = `git rev-parse --abbrev-ref HEAD`.strip
    BUILD_REV_ID       = `git rev-parse HEAD`.strip
    BUILD_REV_ID_SHORT = `git describe --long --tags --dirty --always`.strip
#    if BUILD_BRANCH == 'master'
#      REPO_REVISION="#{REPO_REVISION_}_g#{BUILD_REV_ID_SHORT}".strip
#    else
      REPO_REVISION="#{BUILD_BRANCH}_#{REPO_REVISION_}_r#{BUILD_REV_ID_SHORT}".strip
#    end
    ap REPO_REVISION:REPO_REVISION,
       BUILD_BRANCH:BUILD_BRANCH,
       BUILD_REV_ID:BUILD_REV_ID.strip
  end # task :info
end # namespace :git

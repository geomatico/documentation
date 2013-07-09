Subversion & Github
===================

Source code is in 52n's SVN repo, Development branch is:

  https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/

To develop without interfering, we've created a *mirror* in Github, keeping all the history from SVN branch:

  https://github.com/geomatico/52n-sos-4.0

The mirror has been created with *git-svn*, following these steps::

  # Get the SVN revision where the branch starts (result: 12853)
  svn log --stop-on-copy https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/

  # Create git repo keeping the branch's history (thus ``-r12853``)
  git svn clone -r12853:HEAD https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/ 52n-sos-4

The "master" git branch will be a mirror of the SVN one. DON'T commit any change to this branch, only rebase from original SVN to incorporate latest changes::

  git checkout master    # get master branch
  git svn rebase         # update from svn
  git push origin master # share on github

In this step you may find this error::

  Unable to determine upstream SVN information from working tree history

A solution that may work consists in, first, add this section to .git/config (taken from http://kearneyville.com/2009/07/09/speeding-up-git-svn-for-several-users/ and http://blog.tfnico.com/2010/08/syncing-your-git-repo-with-subversion.html)::

  [svn-remote "svn"]
  url = https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored
  fetch = :refs/remotes/git-svn
  
Then, create the .git/refs/remotes/git-svn file with the SHA of the last commit. The SHA can be obtained with::

  $ git log
  ### Copy commit SHA 

To keep up with SVN changes, first bring them to the "master" branch as expained, then propagate them to the "oracle" branch::

  git checkout oracle    # oracle branch holds our stuff
  git pull master        # incorporate upstream (52n) changes
  git push origin oracle # push changes to github

# AMWA BCP-003 NMOS API Security Recommendations

## GitHub Pages documentation

If you are reading this you are on the gh-pages branch, which is used to generate the documentation from the master and other branches, and from releases.  These are served at <https://amwa-tv.github.io/nmos-api-security>.

_Generating and pushing now happen automatically on changes/daily, but if you need to do this manually, please read on._

## Generating the documentation

Clone this repo (if you haven't already), checkout the gh-pages branch and make:

``git checkout gh-pages``

``make``

This runs scripts to:

- clone the repo from AMWA's GitHub
- for each branch and release (with some exceptions) extract documentation, APIs and schemas
  - making HTML renders of the RAML APIs
- for each branch and release create indexes for the documentation, APIs and schemas
- make links to what will later be the HTML renders of the Markdown documentation

## Updating AMWA's GitHub

Push the updated documentation to AMWA's GitHub with.

``make push``

This then triggers a build of the GitHub Pages. This happens on GitHub's servers, using Jekyll to render the HTML.  This includes rendering the Markdown content, but we have to do the RAML ourselves.  

## Serving pages locally

See also <https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll>

Install Bundler and Jekyll - af you have Ruby installed then:

``gem install bundler``

``bundle install``

Run server with:

``make server``

and browse to the indicated page.
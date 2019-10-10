#!/bin/bash


# Unlike the spec repos, the top-level nmos source-repo doesn't have a docs/ folder

function extract {
    checkout=$1
    target_dir=$2
    echo "Extracting documentation from $checkout into $target_dir"
    mkdir "$target_dir"
    cd source-repo
        git checkout "$checkout"
        cp *.md "../$target_dir/"
        mkdir "../$target_dir/images"
        cp -r images/* "../$target_dir/images"
        cd ..
}

# Find out which branches and tags will be shown
. ./get-config.sh

mkdir branches
for branch in $(cd source-repo; git branch -r | sed 's:origin/::' | grep -v HEAD | grep -v gh-pages); do
    if [[ "$branch" =~ $SHOW_BRANCHES ]]; then
        extract "$branch" "branches/$branch"
    else
        echo Skipping branch $branch
    fi
done

mkdir tags
for tag in $(cd source-repo; git tag); do
    if [[ "$tag" =~ $SHOW_TAGS ]]; then
        extract "tags/$tag" "tags/$tag"
    else
        echo Skipping tag $tag
    fi
done

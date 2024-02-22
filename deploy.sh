#!/usr/bin/env sh

set -e

npm run build

cd dist

git config --global user.email "karmn9988@gmail.com"
git config --global user.name "Kar"
git init
git remote add origin git@github.com:Kar9988/valantis.git
git add --all
git commit -m "Deploy"
git fetch --all
#git push origin main
git push -f git@github.com:Kar9988/valantis.git main:valantis-pages

cd -

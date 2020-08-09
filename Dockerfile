FROM starefossen/github-pages
# run as commandline program
ENTRYPOINT ["jekyll", "serve", "-d", "/_site", "--watch", "--force_polling", "-H", "0.0.0.0", "-P", "4000"]
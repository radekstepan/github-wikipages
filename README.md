# GitHub WikiPages

Turn your GitHub wiki into Pages

![image](https://raw.github.com/radekstepan/github-wikipages/master/example.png)

## Run:

Install all dependencies:

```bash
$ sudo npm install coffee-script -g
$ npm install -d
```

Checkout the wiki:

```bash
$ git submodule init
$ git submodule update
```

Get the latest wiki changes and process the files:

```bash
$ ./update.coffee
```

## Publish:

Now that you have html files in `output` directory, copy them to the `gh_pages` branch of the InterMine project, commit, push.

```bash
$ (cd ../ ; git clone git@github.com:intermine/InterMine.git ; cd InterMine/ ; checkout gh-pages)
$ cp -r output/* ../InterMine/
$ cd ../InterMine
$ git add .
$ git commit -am "My latest wiki changes"
$ git push -u origin gh-pages
```

Visit [http://intermine.github.com/InterMine](http://intermine.github.com/InterMine) to see the latest changes.
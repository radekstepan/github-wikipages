#!/usr/bin/env coffee

fs = require 'fs'
exec = require("child_process").exec
md = require("node-markdown").Markdown
eco = require 'eco'

# Update the directory with all the .md files.
child = exec("(cd input/ ; git pull)", (error, stdout, stderr) ->
    throw error if error isnt null

    write = (path, text, mode = "w") ->
        fs.open path, mode, 0o0666, (e, id) ->
            if e then throw new Error(e)
            fs.write id, text, null, "utf8"

    # Traverse a directory and return a list of .md files (async, recursive).
    (walk = (path, callback) ->
        results = []
        # Read directory.
        fs.readdir path, (err, list) ->
            # Problems?
            return callback err if err
            
            # Get listing length.
            pending = list.length
            
            return callback null, results unless pending # Done already?
            
            # Traverse.
            list.forEach (file) ->
                # Form path
                file = "#{path}/#{file}"
                fs.stat file, (err, stat) ->
                    # Subdirectory.
                    if stat and stat.isDirectory()
                        walk file, (err, res) ->
                            # Append result from sub.
                            results = results.concat(res)
                            callback null, results unless --pending # Done yet?
                    # An .md file?
                    else
                        if file.substr(-3) is '.md' then results.push file
                        callback null, results unless --pending # Done yet?
    ) 'input', (err, resources) ->
        throw err if err

        # Get the eco template.
        fs.readFile "template.eco", "utf8", (err, template) ->
            for file in resources
                markdown = fs.readFileSync(file, "utf-8")

                # Wrap <code> in <pre>.
                markdown = markdown.replace(/```\n([\S\s]*?)```/g, "<pre><code>$1</code></pre>")

                # Convert to HTML and dump through template.
                html = eco.render template, 'content': md markdown
                # Write the output
                write file.replace('Home.md', 'index.htm').replace('.md', '.htm').replace('input/', 'output/'), html
)
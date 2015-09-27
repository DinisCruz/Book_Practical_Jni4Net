require 'fluentnode'

describe 'test', ->
  page        = require('../src/Chrome_Js_Mocha').create(before,after)
  base_Folder = null
  file_README = null

  before ->
    if not process.env.localProjectDir
      process.env.localProjectDir = '.'

    base_Folder = process.env.localProjectDir.path_Combine('../').real_Path()

  it 'check setup',->
    file_README = base_Folder.assert_Folder_Exists().path_Combine('README.md')
    file_README.assert_File_Exists()


  it 'open README file', (done)->
    page.chrome.open "file:///#{file_README}",()->

        console.log 'asdaaaaaaaaa'
        page.html (html,$)->
          console.log $('title').html()
          done()

  xit 'watch test', (done)->
    @timeout 0
    fs = require 'fs'
    target_File = base_Folder.path_Combine 'README.md'



    #fs.watchFile target_File, (eventData)->
    #  "file was changed".log()
    #  page.chrome.open "file:///#{base_Folder}/README.md", ()->

    console.log "Hook set"
    done()

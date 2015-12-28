require 'fluentnode'

Leanpub_Book_API = require '../src/Leanpub-Book-API'

class Generate_Book
  constructor: ->
    @.leanpub_Api = new Leanpub_Book_API()

  create_File_Book: =>
    using @.leanpub_Api, ->
      @.file_Book.delete_File()
      @.folder_content.path_Combine('Book.txt').file_Copy @.file_Book

  copy_Content_Files: =>
    using @.leanpub_Api, ->
      content_Files = @.folder_content.files_Recursive('.md')
      for file in content_Files
        file.file_Copy @.folder_manuscript


module.exports = Generate_Book
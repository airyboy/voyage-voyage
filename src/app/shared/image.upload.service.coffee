angular.module('voyageVoyage').service 'ImageUploadService', (Upload) -> {
  uploadImage: (file, obj) ->
    fileUpload = Upload.http {
      url: 'https://api.parse.com/1/files/pic.jpg',
      headers: { 'Content-Type': 'image/jpeg' },
      data: file }
    fileUpload
      .then (resp) ->
        obj.image = { __type: 'File', name: resp.data.name, url: resp.data.url }
      .catch (err) ->
        alert "Error!"
        console.log err
}

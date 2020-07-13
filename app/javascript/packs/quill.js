import Quill from 'quill/dist/quill.min'
import 'quill/dist/quill.snow.css'

export function setupQuill() {
  let toolbarOptions = [
    ['bold', 'italic', 'underline', 'strike'],
    ['blockquote', 'code-block'],

    [{'header': 1}, {'header': 2}],
    [{'list': 'ordered'}, {'list': 'bullet'}],
    [{'script': 'sub'}, {'script': 'super'}],
    [{'indent': '-1'}, {'indent': '+1'}],
    [{'direction': 'rtl'}],

    [{'size': ['small', false, 'large', 'huge']}],
    [{'header': [1, 2, 3, 4, 5, 6, false]}],

    [{'color': []}, {'background': []}],
    [{'font': []}],
    [{'align': []}],

    ['clean']
  ]

  let editor = new Quill('#content-editor', {
    modules: {
      toolbar: toolbarOptions
    },
    theme: 'snow'
  })

  editor.on('text-change', function () {
    $('#campaign_content').val(editor.root.innerHTML)
  })
}
